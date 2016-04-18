//
//  HoleNode.swift
//  FinalProject
//
//  Created by louis on 6/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class MonsterNode: MapUnitNode {
    var frequencyMin = 2
    var frequencyMax = 2
    var turnsUntilAwake = 0
    var zzzOn = false
    let zzzNode = SKSpriteNode(texture: TextureManager.retrieveTexture("zzz"))
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

    func randomizeTurnsUntilAwake() {
        turnsUntilAwake = Int(arc4random_uniform(UInt32(frequencyMax-frequencyMin)))
            + frequencyMin
    }

    func isAwake() -> Bool {
        return turnsUntilAwake <= 0
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
            randomizeTurnsUntilAwake()
        }
        turnsUntilAwake -= 1
        if isAwake() {
            setAwake()
        }
    }

    func setAwake() {
        texture = TextureManager.monsterDownTexture
        zzzNode.removeAllActions()
        zzzNode.removeFromParent()
        zzzOn = false
    }

    func setSleeping() {
        texture = TextureManager.monsterSleepingTexture
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
}
