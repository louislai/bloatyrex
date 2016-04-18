//
//  HoleNode.swift
//  FinalProject
//
//  Created by louis on 6/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class MonsterNode: MapUnitNode {
    var frequencyMin = 3
    var frequencyMax = 5

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
}
