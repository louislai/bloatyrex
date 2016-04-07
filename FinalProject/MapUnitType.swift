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


    var texture: SKTexture {
        let textures = [
            TextureManager.retrieveTexture("space"),
            TextureManager.agentUpTexture,
            TextureManager.retrieveTexture("wall"),
            TextureManager.retrieveTexture("toilet"),
            TextureManager.retrieveTexture("hole"),
            TextureManager.retrieveTexture("wooden-block")
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
            WoodenBlockNode.self
        ]
        return nodeClasses[rawValue]
    }
}
