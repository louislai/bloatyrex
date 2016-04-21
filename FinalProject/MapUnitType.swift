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

    /// Return the default texture for a particular MapUnitType
    var texture: SKTexture {
        let textures = [
            TextureManager.retrieveTexture(GlobalConstants.ImageNames.space),
            TextureManager.agentDownTexture,
            TextureManager.retrieveTexture(GlobalConstants.ImageNames.wall),
            TextureManager.retrieveTexture(GlobalConstants.ImageNames.goal),
            TextureManager.retrieveTexture(GlobalConstants.ImageNames.hole),
            TextureManager.retrieveTexture(GlobalConstants.ImageNames.wooden_block),
            TextureManager.monsterSleepingTexture,
            TextureManager.retrieveTexture(GlobalConstants.ImageNames.buttons_default),
            TextureManager.retrieveTexture(GlobalConstants.ImageNames.buttons_left),
            TextureManager.retrieveTexture(GlobalConstants.ImageNames.buttons_right)
        ]
        return textures[rawValue]
    }

    /// Return the default SKNode class representing a particular MapUnitType
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
