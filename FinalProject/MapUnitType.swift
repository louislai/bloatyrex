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
    case Monster
    case Door
    case DoorLeft
    case DoorRight

    var texture: SKTexture {
        let textures = [
            TextureManager.retrieveTexture("space"),
            TextureManager.agentDownTexture,
            TextureManager.retrieveTexture("wall"),
            TextureManager.retrieveTexture("toilet"),
            TextureManager.retrieveTexture("hole"),
            TextureManager.retrieveTexture("wooden-block"),
            TextureManager.monsterSleepingTexture,
            TextureManager.retrieveTexture("buttons-unknown"),
            TextureManager.retrieveTexture("buttons-left"),
            TextureManager.retrieveTexture("buttons-right")
        ]
        return textures[rawValue]
    }

    var nodeClass: MapUnitNode.Type {
        let nodeClasses: [MapUnitNode.Type] = [
            MapUnitNode.self,
            AgentNode.self,
            WallNode.self,
            GoalNode.self,
            HoleNode.self,
            WoodenBlockNode.self,
            MonsterNode.self,
            DoorNode.self,
            DoorNode.self,
            DoorNode.self
        ]
        return nodeClasses[rawValue]
    }
}
