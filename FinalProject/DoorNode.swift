//
//  WoodenBlockNode.swift
//  FinalProject
//
//  Created by louis on 6/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

struct DoorNodeConstants {
    static let numberOfButtons = 2
}

class DoorNode: MapUnitNode {
    var correctDoor = 0

    required init(type: MapUnitType = .WoodenBlock) {
        super.init(type: .Door)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    func randomizeDoor() {
        correctDoor = Int(arc4random_uniform(UInt32(DoorNodeConstants.numberOfButtons)))
        if correctDoor == 0 {
            texture = TextureManager.retrieveTexture("buttons-left")
        } else {
            texture = TextureManager.retrieveTexture("buttons-right")
        }
    }
}
