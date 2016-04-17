//
//  WoodenBlockNode.swift
//  FinalProject
//
//  Created by louis on 6/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class DoorNode: MapUnitNode {
    required init(type: MapUnitType = .WoodenBlock) {
        super.init(type: .Door)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
}
