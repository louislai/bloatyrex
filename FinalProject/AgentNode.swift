//
//  Agent.swift
//  FinalProject
//
//  Created by louis on 12/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

enum AgentActionResult {
    case NoResult
    case Win
    case Lose
}

class AgentNode: MapUnitNode {
    var orientation = Direction.Up
    var delegate: LanguageDelegate?
    var numberOfMoves = 0
    var goingToExplode = false

    required init(type: MapUnitType = .Agent) {
        super.init(type: .Agent)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        setOrientationTo(Direction(rawValue: aDecoder.decodeIntegerForKey("orientation"))!)
        self.numberOfMoves = aDecoder.decodeIntegerForKey("moves")
    }

    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeInteger(orientation.rawValue, forKey: "orientation")
        aCoder.encodeInteger(numberOfMoves, forKey: "moves")
    }

    func assignNumberOfMoves(numberOfMoves: Int) {
        self.numberOfMoves = numberOfMoves
    }

    /// Determines the result for the next action
    func runNextAction() -> AgentActionResult {
        guard let delegate = delegate else {
            return .Lose
        }
        if let nextAction = delegate.nextAction(mapNode.map, agent: self) {
            var status = AgentActionResult.NoResult
            var duration: NSTimeInterval = 0.0
            switch nextAction {
            case .NoAction: break
            case .RotateLeft:
                (status, duration) = setOrientationTo(Direction(rawValue: (orientation.rawValue-1+4) % 4)!)
            case .RotateRight:
                (status, duration) = setOrientationTo(Direction(rawValue: (orientation.rawValue+1) % 4)!)
            case .Forward:
                (status, duration) = moveForward()
            case .Jump:
                (status, duration) = jump()
            case .ChooseButton(let buttonNumber, _):
                (status, duration) = chooseButton(buttonNumber)
            }
            guard mapNode.isRowAndColumnSafeFromMonster(row, column: column) else {
                goingToExplode = true
                let waitAction = SKAction.waitForDuration(duration)
                let explodingAction = SKAction.runBlock {
                    self.runExplodingAnimation()
                }
                runAction(SKAction.sequence([
                        waitAction,
                    explodingAction
                    ]))
                return .Lose
            }
            return status
        } else {
            return .Lose
        }
    }

    /// Set the orientation of the agent to a direction
    func setOrientationTo(direction: Direction) -> (status: AgentActionResult, duration: NSTimeInterval) {
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
        return (status: .NoResult, duration: 0)
    }

    // This method checks if the agent would be safe if he was to move forward one step
    func isNextStepSafe() -> Bool {
        if let (nextRow, nextColumn, nextUnit) = nextPosition() {
            guard isReachableUnit(nextUnit) else {
                return true
            }
            let res = mapNode.isRowAndColumnSafeFromMonster(nextRow, column: nextColumn)
            return res
        }
        return true
    }

    func runWinningAnimation() {
        let happyAction = SKAction.animateWithTextures(
            AgentNodeConstants.winningTextures,
            timePerFrame: AgentNodeConstants.timePerFrame
        )
        let happyActionForever = SKAction.repeatActionForever(happyAction)
        runAction(happyActionForever)
    }

    func runLosingAnimation() {
        guard !goingToExplode else {
            return
        }
        let panicAction = SKAction.animateWithTextures(
            AgentNodeConstants.losingTextures,
            timePerFrame: AgentNodeConstants.timePerMoveMovement
        )
        let panicActionForever = SKAction.repeatActionForever(panicAction)
        runAction(panicActionForever)
    }

    private func nextRowAndColumn(steps: Int = 1) -> (row: Int, column: Int)? {
        var nextRow: Int = row
        var nextColumn: Int = column
        switch orientation {
        case .Up:
            guard row < mapNode.map.numberOfRows-steps else {
                return nil
            }
            nextRow += steps
        case .Right:
            guard column < mapNode.map.numberOfColumns-steps else {
                return nil
            }
            nextColumn += steps
        case .Down:
            guard row-steps >= 0 else {
                return nil
            }
            nextRow -= steps
        case .Left:
            guard column-steps >= 0 else {
                return nil
            }
            nextColumn -= steps
        }
        return (row: nextRow, column: nextColumn)
    }

    private func nextPosition(steps: Int = 1) -> (row: Int, column: Int, unit: MapUnitNode)? {
        guard let (nextRow, nextColumn) = nextRowAndColumn(steps) else {
            return nil
        }
        let nextUnit = mapNode.map.retrieveMapUnitAt(nextRow, column: nextColumn)
        return (row: nextRow, column: nextColumn, unit: nextUnit!)
    }

    private func getMoveToAction(toPoint: CGPoint, duration: NSTimeInterval = 0.6) -> SKAction {
        let currentTexture = texture
        let moveAction = SKAction.moveTo(toPoint, duration: duration)
        var movementTextures: [SKTexture]
        switch direction {
        case .Up: movementTextures = AgentNodeConstants.walkingUpTextures
        case .Right: movementTextures = AgentNodeConstants.walkingRightTextures
        case .Down: movementTextures = AgentNodeConstants.walkingDownTextures
        case .Left: movementTextures = AgentNodeConstants.walkingLeftTextures
        }
        let changeTextureAction = SKAction.repeatAction(
            SKAction.animateWithTextures(
                movementTextures,
                timePerFrame: AgentNodeConstants.timePerFrame),
            count: Int(duration / 2 / AgentNodeConstants.timePerFrame)
        )
        let actionSequence = SKAction.sequence([
            SKAction.group([moveAction, changeTextureAction]),
            SKAction.setTexture(currentTexture!)
            ]
        )
        return actionSequence
    }

    private func nextEdgePoint(steps: Int = 1) -> CGPoint? {
        guard let (nextRow, nextColumn, _) = nextPosition(steps) else {
            return nil
        }
        let agentTargetPoint = mapNode.pointFor(nextRow, column: nextColumn)
        let agentCurrentPoint = mapNode.pointFor(row, column: column)
        let contactPoint = CGPoint(
            x: agentCurrentPoint.x + (agentTargetPoint.x - agentCurrentPoint.x) / 2.0,
            y: agentCurrentPoint.y + (agentTargetPoint.y - agentCurrentPoint.y) / 2.0
        )
        return contactPoint
    }

    private func isReachableUnit(unit: MapUnitNode?) -> Bool {
        guard let unit = unit else {
            return false
        }
        let invalidTypes: [MapUnitType] = [.Agent, .Wall, .Hole, .Door, .DoorLeft, .DoorRight, .Monster]
        return !invalidTypes.contains(unit.type)
    }

    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = self.dynamicType.init()
        copy.assignNumberOfMoves(numberOfMoves)
        copy.setOrientationTo(direction)
        return copy
    }
}

// MARK: Jump action
extension AgentNode {
    func jump() -> (status: AgentActionResult, duration: NSTimeInterval) {
        var duration: NSTimeInterval = 0.0
        guard let (nextRow, nextColumn, nextUnit) = nextPosition() else {
            return (status: .NoResult, duration: duration)
        }
        guard let contactPoint = nextEdgePoint() else {
            return (status: .NoResult, duration: duration)
        }
        let agentMoveToContactPointAction = getMoveToAction(
            contactPoint,
            duration: AgentNodeConstants.timePerMoveMovement * 0.1
        )
        duration += AgentNodeConstants.timePerMoveMovement * 0.1
        guard let (nextNextRow, nextNextColumn, nextNextUnit) = nextPosition(2)
            where nextUnit.type == .Hole && isReachableUnit(nextNextUnit) else {
                let failureAction = getMoveToAction(
                    mapNode.pointFor(row, column: column),
                    duration: AgentNodeConstants.timePerMoveMovement * 0.1
                )
                duration += AgentNodeConstants.timePerMoveMovement * 0.1
                let failureSequence = SKAction.sequence([
                    agentMoveToContactPointAction,
                    failureAction
                    ])
                runAction(failureSequence)
                return (status: .NoResult, duration: duration)
        }

        mapNode.map.clearMapUnitAt(row, column: column)
        row = nextNextRow
        column = nextNextColumn

        // Move sprite
        let targetPoint = mapNode.pointFor(row, column: column)
        let jumpAction = SKAction.moveTo(
            targetPoint,
            duration: AgentNodeConstants.timePerMoveMovement*0.4
        )
        duration += AgentNodeConstants.timePerMoveMovement*0.4
        let jumpSequence = SKAction.sequence(
            [
                agentMoveToContactPointAction,
                jumpAction
            ]
        )
        runAction(jumpSequence)

        if nextNextUnit.type == .Goal {
            return (status: .Win, duration: duration)
        }
        mapNode.map.setMapUnitAt(self, row: nextRow, column: nextColumn)
        return (status: .NoResult, duration: duration)
    }
}

// MARK: Move forward action
extension AgentNode {
    func moveForward() -> (status: AgentActionResult, duration: NSTimeInterval) {
        var duration: NSTimeInterval = 0.0
        if let (nextRow, nextColumn, nextUnit) = nextPosition() {
            // Branch off to push method if nextUnit is a wooden block
            if nextUnit.type == .WoodenBlock {
                return push()
            }
            guard isReachableUnit(nextUnit) else {
                return (status: .NoResult, duration)
            }

            mapNode.map.clearMapUnitAt(row, column: column)


            row = nextRow
            column = nextColumn

            // Move sprite
            let targetPoint = mapNode.pointFor(row, column: column)
            runAction(getMoveToAction(targetPoint))
            duration += AgentNodeConstants.timePerMoveMovement

            if nextUnit.type == .Goal {
                return (status: .Win, duration: duration)
            }
            mapNode.map.setMapUnitAt(self, row: nextRow, column: nextColumn)
        }
        return (status: .NoResult, duration: duration)
    }
}

// MARK: Push action
extension AgentNode {
    func push() -> (status: AgentActionResult, duration: NSTimeInterval) {
        var duration: NSTimeInterval = 0.0
        guard let (nextRow, nextColumn, nextUnit) = nextPosition() else {
            return (status: .NoResult, duration: duration)
        }
        guard let contactPoint = nextEdgePoint() else {
            return (status: .NoResult, duration: duration)
        }
        let agentMoveToContactPointAction = getMoveToAction(
            contactPoint,
            duration: AgentNodeConstants.timePerMoveMovement * 0.1
        )
        duration += AgentNodeConstants.timePerMoveMovement * 0.1
        guard let (nextNextRow, nextNextColumn, nextNextUnit) = nextPosition(2),
            nextContactPoint = nextEdgePoint(2)
            where nextNextUnit.type == .EmptySpace && nextUnit.type == .WoodenBlock else {
                let failureAction = getMoveToAction(
                    mapNode.pointFor(row, column: column),
                    duration: AgentNodeConstants.timePerMoveMovement * 0.1
                )
                duration += AgentNodeConstants.timePerMoveMovement * 0.1
                let failureSequence = SKAction.sequence([
                    agentMoveToContactPointAction,
                    failureAction
                    ])
                runAction(failureSequence)
                return (status: .NoResult, duration: duration)
        }
        let agentTargetPoint = mapNode.pointFor(nextRow, column: nextColumn)
        let woodenBlockTargetPoint = mapNode.pointFor(nextNextRow, column: nextNextColumn)
        let agentPushAction = getMoveToAction(nextContactPoint, duration: AgentNodeConstants.timePerMoveMovement * 0.3)
        duration += AgentNodeConstants.timePerMoveMovement * 0.3
        let agentRetreatAction = getMoveToAction(
            agentTargetPoint,
            duration: AgentNodeConstants.timePerMoveMovement * 0.1
        )
        duration += AgentNodeConstants.timePerMoveMovement * 0.1
        let allAgentActions = SKAction.sequence(
            [
                agentMoveToContactPointAction,
                agentPushAction,
                agentRetreatAction
            ]
        )

        let blockPushAction = SKAction.moveTo(
            woodenBlockTargetPoint,
            duration: AgentNodeConstants.timePerMoveMovement*0.3
        )
        let allBlockActions = SKAction.sequence(
            [
                SKAction.waitForDuration(AgentNodeConstants.timePerMoveMovement*0.1),
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
        nextUnit.row = nextNextRow
        nextUnit.column = nextNextColumn
        mapNode.map.setMapUnitAt(self, row: row, column: column)
        return (status: .NoResult, duration: duration)
    }
}

// MARK: Choose button action
extension AgentNode {
    func chooseButton(buttonNumber: Int) -> (status: AgentActionResult, duration: NSTimeInterval) {
        guard let (nextRow, nextColumn, nextUnit) = nextPosition() else {
            return (status: .NoResult, duration: 0)
        }
        guard let door = nextUnit as? DoorNode else {
            return (status: .NoResult, duration: 0)
        }
        if door.type == .DoorLeft && buttonNumber == DoorNodeConstants.doorLeft ||
            door.type == .DoorRight && buttonNumber == DoorNodeConstants.doorRight {
            mapNode.map.clearMapUnitAt(nextRow, column: nextColumn)
            door.runExplodingAnimation()
            return (status: .NoResult, duration: 0)
        } else {
            for goal in mapNode.goalNodes {
                goal.runExplodingAnimation()
            }
            return (status: .Lose, duration: 0)
        }
    }
}
