//
//  File.swift
//  FinalProject
//
//  Created by louis on 10/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

enum MapUnitType: Int {
    case EmptySpace = 0
    case Agent
    case Wall
    case Goal
    case Hole
    case WoodenBlock


    var spriteName: String {
        let spriteNames = [
            "",
            "agent",
            "wall",
            "toilet",
            "hole",
            "wooden-block"
        ]
        return spriteNames[rawValue]
    }
}
