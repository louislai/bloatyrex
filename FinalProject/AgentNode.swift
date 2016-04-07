//
//  Agent.swift
//  FinalProject
//
//  Created by louis on 12/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class AgentNode: MapUnitNode {
    weak var mapNode: MapNode!
    var orientation = Direction.Up
    var row: Int!
    var column: Int!
    var delegate: LanguageDelegate?
    var callbackAction = SKAction.runBlock {}
    var numberOfMoves = 11
    let timePerMoveMovement: NSTimeInterval = 0.5

    required init(type: MapUnitType = .Agent) {
        super.init(type: .Agent)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    /// Return true if nextAction causes the agent to reach the goal
    /// Return false if program terminates while not reaching the goal
    /// Return nil if undecided
    func runNextAction() -> Bool? {
        guard let delegate = delegate else {
            return false
        }
        if let nextAction = delegate.nextAction(mapNode.map, agent: self) {
            print(nextAction)
            switch nextAction {
            case .NoAction:
                return nil
            case .RotateLeft:
                setOrientationTo(Direction(rawValue: (orientation.rawValue-1+4) % 4)!)
                return nil
            case .RotateRight:
                setOrientationTo(Direction(rawValue: (orientation.rawValue+1) % 4)!)
                return nil
            case .Forward:
                return moveForward()
            }
        } else {
            return false
        }
    }

    func setOrientationTo(direction: Direction) {
        orientation = direction
        switch orientation {
        case .Up:
            texture = TextureManager.agentUpTexture
        case .Right:
            texture = TextureManager.agentRightTexture
        case .Down:
            texture = TextureManager.agentDownTexture
        case .Left:
            texture = TextureManager.agentLeftTexture
        }
    }

    /// Return true if moveForward causes the agent to reach the goal
    /// Return nil if undecided
    func moveForward() -> Bool? {
        if let (nextRow, nextColumn, nextUnit) = nextPosition() {
            mapNode.map.clearMapUnitAt(row, column: column)


            row = nextRow
            column = nextColumn

            // Move sprite
            let targetPoint = mapNode.pointFor(row, column: column)
            let moveAction = SKAction.moveTo(targetPoint, duration: timePerMoveMovement)
            runAction(moveAction)

            if nextUnit.type == .Goal {
                return true
            }
            mapNode.map.setMapUnitAt(self, row: nextRow, column: nextColumn)
        }
        return nil
    }

    func runWinningAnimation() {
        let textures = [
            TextureManager.agentUpTexture, TextureManager.agentRightTexture, TextureManager.agentDownTexture, TextureManager.agentLeftTexture
        ]
        let rotationAction = SKAction.repeatAction(
            SKAction.animateWithTextures(textures, timePerFrame: 0.1), count: 5
        )
        let scaleDownAction = SKAction.scaleBy(0, duration: 2)
        let group = SKAction.group([rotationAction, scaleDownAction])
        let sequence = SKAction.sequence([
            SKAction.waitForDuration(timePerMoveMovement), group, SKAction.removeFromParent()]
        )
        runAction(sequence)
    }

    func runLosingAnimation() {
        let textureAction = SKAction.setTexture(TextureManager.retrieveTexture("poo"))
        let leftWiggle = SKAction.rotateByAngle(CGFloat(M_PI/8.0), duration: 0.25)
        let rightWiggle = leftWiggle.reversedAction()
        let fullWiggle = SKAction.repeatAction(
            SKAction.sequence([leftWiggle, rightWiggle]), count: 4)
        let scaleDownAction = SKAction.scaleBy(0, duration: 2)
        let group = SKAction.group([textureAction, scaleDownAction, fullWiggle])
        let sequence = SKAction.sequence([
            SKAction.waitForDuration(timePerMoveMovement), group, SKAction.removeFromParent()]
        )
        runAction(sequence)
    }

    private func nextPosition() -> (row: Int, column: Int, unit: MapUnitNode)? {
        var nextRow: Int = row
        var nextColumn: Int = column
        switch orientation {
        case .Up:
            guard row < mapNode.map.numberOfRows-1 else {
                return nil
            }
            nextRow += 1
        case .Right:
            guard column < mapNode.map.numberOfColumns-1 else {
                return nil
            }
            nextColumn += 1
        case .Down:
            guard row > 0 else {
                return nil
            }
            nextRow -= 1
        case .Left:
            guard column > 0 else {
                return nil
            }
            nextColumn -= 1

        }
        let unit = mapNode.map.retrieveMapUnitAt(nextRow, column: nextColumn)
        guard let nextUnit = unit else {
            return nil
        }
        guard nextUnit.type != .Agent && nextUnit.type != .Wall else {
            return nil
        }
        return (row: nextRow, column: nextColumn, unit: nextUnit)
    }
}

extension AgentNode: AgentProtocol {
    var xPosition: Int {
        return column
    }
    var yPosition: Int {
        return row
    }
    var direction: Direction {
        return orientation
    }
}
