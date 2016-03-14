//
//  File.swift
//  FinalProject
//
//  Created by louis on 10/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

enum MapUnit: Int {
    case EmptySpace = 0
    case Agent
    case Wall
    case Goal

    var spriteName: String {
        let spriteNames = [
            "",
            "agent",
            "wall",
            "toilet"
        ]
        return spriteNames[rawValue]
    }

    var spriteClass: SKSpriteNode.Type {
        let classes: [SKSpriteNode.Type] = [
            EmptySpaceNode.self,
            AgentNode.self,
            WallNode.self,
            GoalNode.self
        ]
        return classes[rawValue]
    }
}
