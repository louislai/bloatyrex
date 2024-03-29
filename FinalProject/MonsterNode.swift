//
//  HoleNode.swift
//  FinalProject
//
//  Created by louis on 6/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

struct MonsterNodeConstants {
    static let deadZoneNodeName = "deadZone"
    static let frequencyMin = 2
    static let frequencyMax = 5
}

class MonsterNode: MapUnitNode {
    var frequencyMin = MonsterNodeConstants.frequencyMin
    var frequencyMax = MonsterNodeConstants.frequencyMax
    var turnsUntilAwake = 0
    var zzzOn = false
    let zzzNode = SKSpriteNode(texture: TextureManager.retrieveTexture(
            GlobalConstants.ImageNames.sleeping
        ))
    var deadZoneNodes = [SKSpriteNode]()
    var indicatorNode: SKLabelNode?
    let timePerAnimation: NSTimeInterval = 0.15

    required init(type: MapUnitType = .Hole) {
        super.init(type: .Monster)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.frequencyMin = aDecoder.decodeIntegerForKey("fmin")
        self.frequencyMax = aDecoder.decodeIntegerForKey("fmax")
    }

    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeInteger(frequencyMin, forKey: "fmin")
        aCoder.encodeInteger(frequencyMax, forKey: "fmax")
    }

    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = self.dynamicType.init()
        copy.frequencyMin = frequencyMin
        copy.frequencyMax = frequencyMax
        return copy
    }

    func isAwake(steps: Int = 0) -> Bool {
        return turnsUntilAwake == 0
    }

    func initializeTurnsUntilAwake() {
        turnsUntilAwake = randomizeTurnsUntilAwake()
    }

    func setOrientation(orientation: Direction) {
        setAwake()
        xScale = 1
        zzzNode.xScale = 1
        switch orientation {
        case .Up:
            texture = TextureManager.monsterUpTexture
        case .Down:
            texture = TextureManager.monsterDownTexture
        case .Left:
            xScale = -1
            zzzNode.xScale = -1
            fallthrough
        case .Right:
            texture = TextureManager.monsterRightTexture
        }
    }

    /// Carry out this turn's action
    /// Return true if monster is awake this turns
    /// Return false otherwise
    func nextAction() {
        if isAwake() {
            initializeTurnsUntilAwake()
            setSleeping()
        }
        turnsUntilAwake = max(turnsUntilAwake-1, 0)
        updateIndicator()
        if isAwake() {
            setAwake()
        }
    }

    func setAwake() {
        texture = TextureManager.monsterDownTexture
        zzzNode.removeAllActions()
        zzzNode.removeFromParent()
        zzzOn = false
        showDeadZones()
    }

    func setSleeping() {
        texture = TextureManager.monsterSleepingTexture
        hideDeadZones()
        zzzNode.zPosition = GlobalConstants.zPosition.front
        if !zzzOn {
            let bWidth = GlobalConstants.Dimension.blockWidth
            let bHeight = GlobalConstants.Dimension.blockHeight
            let smallSize = CGSize(
                width: bWidth*0.5,
                height: bHeight*0.5
            )
            zzzNode.size = smallSize
            let resizeSmallAction = SKAction.resizeToWidth(
                bWidth*0.5,
                height: bHeight*0.5,
                duration: timePerAnimation
            )
            resizeSmallAction.timingMode = .EaseIn
            let resizeBigAction = SKAction.resizeToWidth(
                bWidth,
                height: bHeight,
                duration: timePerAnimation
            )
            resizeBigAction.timingMode = .EaseOut
            let actionSequence = SKAction.repeatActionForever(
                SKAction.sequence([
                    resizeSmallAction,
                    resizeBigAction
                    ])
            )
            addChild(zzzNode)
            zzzNode.runAction(actionSequence)
            zzzOn = true
        }
    }

    private func updateIndicator() {
        if indicatorNode == nil {
            indicatorNode = SKLabelNode(fontNamed: GlobalConstants.Font.defaultNameBold)
            indicatorNode!.fontColor = UIColor.orangeColor()
            indicatorNode!.verticalAlignmentMode = .Center
            indicatorNode!.zPosition = GlobalConstants.zPosition.front
            addChild(indicatorNode!)
        }
        indicatorNode!.text = "\(turnsUntilAwake)"
    }

    private func randomizeTurnsUntilAwake() -> Int {
        return Int(arc4random_uniform(UInt32(frequencyMax-frequencyMin)))
            + frequencyMin
    }

    private func showDeadZones() {
        let blueprintDeadZone = SKSpriteNode(
            texture: TextureManager.retrieveTexture(
                GlobalConstants.ImageNames.skull
            ))
        blueprintDeadZone.zPosition = GlobalConstants.zPosition.back
        blueprintDeadZone.size = mapNode.blockSize
        blueprintDeadZone.name = MonsterNodeConstants.deadZoneNodeName
        if row + 1 <= mapNode.map.numberOfRows-1 {
            let copy = blueprintDeadZone.copy() as! SKSpriteNode
            copy.position = mapNode.pointFor(row+1, column: column)
            mapNode.unitsLayer.addChild(copy)
            deadZoneNodes.append(copy)
        }
        if row - 1 >= 0 {
            let copy = blueprintDeadZone.copy() as! SKSpriteNode
            copy.position = mapNode.pointFor(row-1, column: column)
            mapNode.unitsLayer.addChild(copy)
            deadZoneNodes.append(copy)
        }
        if column + 1 <= mapNode.map.numberOfColumns-1 {
            let copy = blueprintDeadZone.copy() as! SKSpriteNode
            copy.position = mapNode.pointFor(row, column: column+1)
            mapNode.unitsLayer.addChild(copy)
            deadZoneNodes.append(copy)
        }
        if column - 1 >= 0 {
            let copy = blueprintDeadZone.copy() as! SKSpriteNode
            copy.position = mapNode.pointFor(row, column: column-1)
            mapNode.unitsLayer.addChild(copy)
            deadZoneNodes.append(copy)
        }
    }

    private func hideDeadZones() {
        for node in deadZoneNodes {
            node.removeFromParent()
        }
        deadZoneNodes.removeAll()
    }
}
