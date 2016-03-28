//
//  Agent.swift
//  FinalProject
//
//  Created by louis on 12/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class AgentNode: SKSpriteNode {
    weak var gameScene: PlayingMapScene!
    var orientation = Direction.Up
    var row: Int!
    var column: Int!
    var delegate: LanguageDelegate?
    let timePerMoveMovement: NSTimeInterval = 0.5

    // Return true if nextAction causes the agent to reach the goal
    func runNextAction() -> Bool {
        guard let delegate = delegate else {
            return false
        }
        if let nextAction = delegate.nextAction(gameScene.map, agent: self) {
            print(nextAction)
            switch nextAction {
            case .NoAction:
                return false
            case .RotateLeft:
                setOrientationTo(Direction(rawValue: (orientation.rawValue-1+4) % 4)!)
                return false
            case .RotateRight:
                setOrientationTo(Direction(rawValue: orientation.rawValue+1 % 4)!)
                return false
            case .Forward:
                return moveForward()
            }
        }
        return false
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

    // Return true if moveForward causes the agent to reach the goal
    func moveForward() -> Bool {
        if let (nextRow, nextColumn, nextUnit) = nextPosition() {
            gameScene.map.clearMapUnitAt(row, column: column)


            row = nextRow
            column = nextColumn

            // Move sprite
            let targetPoint = gameScene.pointFor(row, column: column)
            let moveAction = SKAction.moveTo(targetPoint, duration: timePerMoveMovement)
            runAction(moveAction)

            if nextUnit == .Goal {
                return true
            }
            gameScene.map.setMapUnitAt(.Agent, row: nextRow, column: nextColumn)
        }
        return false
    }

    private func nextPosition() -> (row: Int, column: Int, unit: MapUnit)? {
        var nextRow: Int = row
        var nextColumn: Int = column
        switch orientation {
        case .Up:
            guard row < gameScene.map.numberOfRows-1 else {
                return nil
            }
            nextRow += 1
        case .Right:
            guard column < gameScene.map.numberOfColumns-1 else {
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
        let unit = gameScene.map.retrieveMapUnitAt(nextRow, column: nextColumn)
        guard let nextUnit = unit else {
            return nil
        }
        guard nextUnit != .Agent && nextUnit != .Wall else {
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
