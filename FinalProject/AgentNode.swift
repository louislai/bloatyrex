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
    var numberOfMoves = 30
    let timePerMoveMovement: NSTimeInterval = 0.6
    let timePerFrame: NSTimeInterval = 0.1
    let walkingUpTextures = [
        SKTexture(
            rect: CGRect(
                x: 22.0/521.0,
                y: 48.0/175.0,
                width: 21.0/521.0,
                height: 39.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        ),
        SKTexture(
            rect: CGRect(
                x: 64.0/521.0,
                y: 48.0/175.0,
                width: 21.0/521.0,
                height: 39.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        )
    ]
    let walkingRightTextures = [
        SKTexture(
            rect: CGRect(
                x: 149.0/521.0,
                y: 87.0/175.0,
                width: 25.0/521.0,
                height: 39.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        ),
        SKTexture(
            rect: CGRect(
                x: 203.0/521.0,
                y: 87.0/175.0,
                width: 25.0/521.0,
                height: 39.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        )
    ]
    let walkingLeftTextures = [
        SKTexture(
            rect: CGRect(
                x: 148.0/521.0,
                y: 45.0/175.0,
                width: 25.0/521.0,
                height: 39.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        ),
        SKTexture(
            rect: CGRect(
                x: 202.0/521.0,
                y: 45.0/175.0,
                width: 25.0/521.0,
                height: 39.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        )
    ]
    let walkingDownTextures = [
        SKTexture(
            rect: CGRect(
                x: 22.0/521.0,
                y: 88.0/175.0,
                width: 21.0/521.0,
                height: 39.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        ),
        SKTexture(
            rect: CGRect(
                x: 64.0/521.0,
                y: 88.0/175.0,
                width: 21.0/521.0,
                height: 39.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        )
    ]
    let winningTextures = [
        SKTexture(
            rect: CGRect(
                x: 417.0/521.0,
                y: 47.0/175.0,
                width: 29.0/521.0,
                height: 40.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        ),
        SKTexture(
            rect: CGRect(
                x: 484.0/521.0,
                y: 47.0/175.0,
                width: 29.0/521.0,
                height: 40.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        )
    ]
    let losingTextures = [
        SKTexture(
            rect: CGRect(
                x: 270.0/521.0,
                y: 47.0/175.0,
                width: 29.0/521.0,
                height: 40.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        ),
        SKTexture(
            rect: CGRect(
                x: 271.0/521.0,
                y: 87.0/175.0,
                width: 25.0/521.0,
                height: 39.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        )
    ]

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
    
    func resetInterpreter() {
        delegate?.resetInterpreter()
    }

    func assignNumberOfMoves(numberOfMoves: Int) {
        self.numberOfMoves = numberOfMoves
    }

    /// Return true if nextAction causes the agent to reach the goal
    /// Return false if program terminates while not reaching the goal
    /// Return nil if undecided
    func runNextAction() -> Bool? {
        guard let delegate = delegate else {
            return false
        }
        if let nextAction = delegate.nextAction(mapNode.map, agent: self) {
            guard mapNode.isRowAndColumnSafeFromMonster(row, column: column) else {
                runExplodingAnimation()
                return false
            }
            switch nextAction {
            case .NoAction: return nil
            case .RotateLeft:
                return setOrientationTo(Direction(rawValue: (orientation.rawValue-1+4) % 4)!)
            case .RotateRight:
                return setOrientationTo(Direction(rawValue: (orientation.rawValue+1) % 4)!)
            case .Forward:
                return moveForward()
            case .Jump:
                return jump()
            case .ChooseButton(let buttonNumber, _):
                return chooseButton(buttonNumber)
            }
        } else {
            return false
        }
    }

    func setOrientationTo(direction: Direction) -> Bool? {
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
        return nil
    }

    func runWinningAnimation() {
        let happyAction = SKAction.animateWithTextures(
            winningTextures,
            timePerFrame: timePerFrame
        )
        let happyActionForever = SKAction.repeatActionForever(happyAction)
        runAction(happyActionForever)
    }

    func runLosingAnimation() {
        guard !exploded else {
            return
        }
        let panicAction = SKAction.animateWithTextures(
            losingTextures,
            timePerFrame: timePerMoveMovement
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
        case .Up: movementTextures = walkingUpTextures
        case .Right: movementTextures = walkingRightTextures
        case .Down: movementTextures = walkingDownTextures
        case .Left: movementTextures = walkingLeftTextures
        }
        let changeTextureAction = SKAction.repeatAction(
            SKAction.animateWithTextures(
                movementTextures,
                timePerFrame: timePerFrame),
            count: Int(duration / 2 / timePerFrame)
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
        let invalidTypes: [MapUnitType] = [.Agent, .Wall, .Hole, .Door, .Monster]
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
    /// Return true if jump causes the agent to reach the goal
    /// Return nil if undecided
    func jump() -> Bool? {
        guard let (nextRow, nextColumn, nextUnit) = nextPosition() else {
            return nil
        }
        guard let contactPoint = nextEdgePoint() else {
            return nil
        }
        let agentMoveToContactPointAction = getMoveToAction(
            contactPoint,
            duration: timePerMoveMovement * 0.5
        )
        guard let (nextNextRow, nextNextColumn, nextNextUnit) = nextPosition(2)
            where nextUnit.type == .Hole && isReachableUnit(nextNextUnit) else {
                let failureAction = getMoveToAction(
                    mapNode.pointFor(row, column: column),
                    duration: timePerMoveMovement * 0.5
                )
                let failureSequence = SKAction.sequence([
                    agentMoveToContactPointAction,
                    failureAction
                    ])
                runAction(failureSequence)
                return nil
        }

        mapNode.map.clearMapUnitAt(row, column: column)
        row = nextNextRow
        column = nextNextColumn

        // Move sprite
        let targetPoint = mapNode.pointFor(row, column: column)
        let jumpAction = SKAction.moveTo(targetPoint, duration: timePerMoveMovement)
        let jumpSequence = SKAction.sequence(
            [
                agentMoveToContactPointAction,
                jumpAction
            ]
        )
        runAction(jumpSequence)

        if nextNextUnit.type == .Goal {
            return true
        }
        mapNode.map.setMapUnitAt(self, row: nextRow, column: nextColumn)
        return nil
    }
}

// MARK: Move forward action
extension AgentNode {
    /// Return true if moveForward causes the agent to reach the goal
    /// Return false if moveForward causes the agent to lose
    /// Return nil if undecided
    func moveForward() -> Bool? {
        if let (nextRow, nextColumn, nextUnit) = nextPosition() {
            // Branch off to push method if nextUnit is a wooden block
            if nextUnit.type == .WoodenBlock {
                return push()
            }
            guard isReachableUnit(nextUnit) else {
                return nil
            }

            mapNode.map.clearMapUnitAt(row, column: column)


            row = nextRow
            column = nextColumn

            // Move sprite
            let targetPoint = mapNode.pointFor(row, column: column)
            runAction(getMoveToAction(targetPoint))

            if nextUnit.type == .Goal {
                return true
            }
            mapNode.map.setMapUnitAt(self, row: nextRow, column: nextColumn)
        }
        return nil
    }
}

// MARK: Push action
extension AgentNode {
    /// Return true if push causes the agent to reach the goal
    /// Return nil if undecided
    func push() -> Bool? {
        guard let (nextRow, nextColumn, nextUnit) = nextPosition() else {
            return nil
        }
        guard let contactPoint = nextEdgePoint() else {
            return nil
        }
        let agentMoveToContactPointAction = getMoveToAction(
            contactPoint,
            duration: timePerMoveMovement * 0.5
        )
        guard let (nextNextRow, nextNextColumn, nextNextUnit) = nextPosition(2),
            nextContactPoint = nextEdgePoint(2)
            where nextNextUnit.type == .EmptySpace && nextUnit.type == .WoodenBlock else {
                let failureAction = getMoveToAction(
                    mapNode.pointFor(row, column: column),
                    duration: timePerMoveMovement * 0.5
                )
                let failureSequence = SKAction.sequence([
                    agentMoveToContactPointAction,
                    failureAction
                    ])
                runAction(failureSequence)
                return nil
        }
        let agentTargetPoint = mapNode.pointFor(nextRow, column: nextColumn)
        let woodenBlockTargetPoint = mapNode.pointFor(nextNextRow, column: nextNextColumn)
        let agentPushAction = getMoveToAction(nextContactPoint)
        let agentRetreatAction = getMoveToAction(
            agentTargetPoint,
            duration: timePerMoveMovement * 0.5
        )
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
}

// MARK: Choose button action
extension AgentNode {
    /// Return nil if choosing causes the door to be unlocked, or invalid action
    /// Return false if choosing causes the toilet to explode and lose
    func chooseButton(buttonNumber: Int) -> Bool? {
        guard let (nextRow, nextColumn, nextUnit) = nextPosition() else {
            return nil
        }
        guard let door = nextUnit as? DoorNode else {
            return nil
        }
        if door.correctDoor == buttonNumber {
            mapNode.map.clearMapUnitAt(nextRow, column: nextColumn)
            door.runExplodingAnimation()
            return nil
        } else {
            for goal in mapNode.goalNodes {
                goal.runExplodingAnimation()
            }
            return false
        }
    }

    func isNextStepSafe() -> Bool {
        if let (nextRow, nextColumn) = nextRowAndColumn() {
            return mapNode.isRowAndColumnSafeFromMonster(nextRow, column: nextColumn)
        }
        return true
    }
}
