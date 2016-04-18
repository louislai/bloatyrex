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

    /// Carry out this turn's action
    /// Return true if monster is awake this turns
    /// Return false otherwise
    func nextAction() -> Bool {
        if isAwake() {
            randomizeTurnsUntilAwake()
            return true
        } else {
            turnsUntilAwake -= 1
            return false
        }
    }
}
