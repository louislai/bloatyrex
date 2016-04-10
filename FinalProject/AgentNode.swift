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
            case .Jump:
                return jump()
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
    /// Return false if moveForward causes the agent to lose
    /// Return nil if undecided
    func moveForward() -> Bool? {
        if let (nextRow, nextColumn, nextUnit) = nextPosition() {
            // Branch off to push method if nextUnit is a wooden block
            if nextUnit.type == .WoodenBlock {
                return push()
            }


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

    /// Return true if push causes the agent to reach the goal
    /// Return nil if undecided
    func push() -> Bool? {
        let widthCorrection: CGFloat = 0.0
        guard let (nextRow, nextColumn, nextUnit) = nextPosition() else {
            return nil
        }
        guard let (nextNextRow, nextNextColumn, nextNextUnit) = nextPosition(2) else {
            return nil
        }
        guard nextNextUnit.type == .EmptySpace else {
            return nil
        }
        let agentTargetPoint = mapNode.pointFor(nextRow, column: nextColumn)
        let woodenBlockTargetPoint = mapNode.pointFor(nextNextRow, column: nextNextColumn)
        let agentCurrentPoint = mapNode.pointFor(row, column: column)
        let contactPoint = CGPoint(
            x: agentCurrentPoint.x + (agentTargetPoint.x - agentCurrentPoint.x) / 2.0 - widthCorrection,
            y: agentCurrentPoint.y + (agentTargetPoint.y - agentCurrentPoint.y) / 2.0 - widthCorrection
        )
        let agentMoveToContactPointAction = SKAction.moveTo(
            contactPoint,
            duration: timePerMoveMovement * 0.5
        )
        let nextContactPoint = CGPoint(
            x: contactPoint.x + (agentTargetPoint.x - agentCurrentPoint.x) / 2.0,
            y: contactPoint.y + (agentTargetPoint.y - agentCurrentPoint.y) / 2.0
        )
        let agentPushAction = SKAction.moveTo(
            nextContactPoint,
            duration: timePerMoveMovement
        )
        let agentRetreatAction = SKAction.moveTo(agentTargetPoint, duration: timePerMoveMovement * 0.5)
        let allAgentActions = SKAction.sequence(
            [
                agentMoveToContactPointAction,
                agentPushAction,
                agentRetreatAction
            ]
        )

        let blockPushAction = SKAction.moveTo(woodenBlockTargetPoint, duration: timePerMoveMovement)
        let allBlockActions = SKAction.sequence(
            [
                SKAction.waitForDuration(timePerMoveMovement*0.5),
                blockPushAction
            ]
        )
        runAction(allAgentActions)
        nextUnit.runAction(allBlockActions)

        // Change map
        mapNode.map.clearMapUnitAt(row, column: column)
        mapNode.map.setMapUnitAt(nextUnit, row: nextNextRow, column: nextNextColumn)
        row = nextRow
        column = nextColumn
        mapNode.map.setMapUnitAt(self, row: row, column: column)
        return nil
    }

    /// Return true if jump causes the agent to reach the goal
    /// Return nil if undecided
    func jump() -> Bool? {
        guard let (nextRow, nextColumn, nextUnit) = nextPosition() else {
            return nil
        }
        guard let (nextNextRow, nextNextColumn, nextNextUnit) = nextPosition(2) else {
            return nil
        }
        guard nextUnit.type == .Hole else {
            return nil
        }
        guard isReachableUnit(nextNextUnit) else {
            return nil
        }

        mapNode.map.clearMapUnitAt(row, column: column)


        row = nextNextRow
        column = nextNextColumn

        // Move sprite
        let targetPoint = mapNode.pointFor(row, column: column)
        let moveAction = SKAction.moveTo(targetPoint, duration: timePerMoveMovement*2.0)
        runAction(moveAction)

        if nextNextUnit.type == .Goal {
            return true
        }
        mapNode.map.setMapUnitAt(self, row: nextRow, column: nextColumn)
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

    private func nextPosition(step: Int = 1) -> (row: Int, column: Int, unit: MapUnitNode)? {
        var nextRow: Int = row
        var nextColumn: Int = column
        switch orientation {
        case .Up:
            guard row < mapNode.map.numberOfRows-step else {
                return nil
            }
            nextRow += step
        case .Right:
            guard column < mapNode.map.numberOfColumns-step else {
                return nil
            }
            nextColumn += step
        case .Down:
            guard row-step >= 0 else {
                return nil
            }
            nextRow -= step
        case .Left:
            guard column-step >= 0 else {
                return nil
            }
            nextColumn -= step

        }
        let nextUnit = mapNode.map.retrieveMapUnitAt(nextRow, column: nextColumn)

        guard isReachableUnit(nextUnit) else {
            return nil
        }
        return (row: nextRow, column: nextColumn, unit: nextUnit!)
    }

    private func isReachableUnit(unit: MapUnitNode?) -> Bool {
        guard let unit = unit else {
            return false
        }
        let invalidTypes: [MapUnitType] = [.Agent, .Wall, .Hole, .Signboard, .Monster, .Key]
        return !invalidTypes.contains(unit.type)
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
