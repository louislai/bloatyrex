//
//  Wall.swift
//  FinalProject
//
//  Created by louis on 13/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class WallNode: MapUnitNode {
    required init(type: MapUnitType = .Wall) {
        super.init(type: .Wall)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
}
