//
//  File.swift
//  FinalProject
//
//  Created by louis on 10/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

enum MapUnit: Int {
    case EmptySpace = 0
    case Agent
    case Wall
    case Goal

    var spriteName: String {
        let spriteNames = [
            "",
            "trex.png",
            "wall.png",
            "toilet.png"
        ]
        return spriteNames[rawValue]
    }
}
