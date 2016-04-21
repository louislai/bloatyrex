//
//  TextureManager.swift
//  FinalProject
//
//  Created by louis on 13/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// Texture Manager uses singleton pattern to manage the textures

import SpriteKit

class TextureManager {
    static var textureDictionary = [String: SKTexture]()
    static func retrieveTexture(imageNamed: String) -> SKTexture {
        if let texture = textureDictionary[imageNamed] {
            return texture
        } else {
            let texture = SKTexture(imageNamed: imageNamed)
            textureDictionary[imageNamed] = texture
            return texture
        }
    }
    static let agentUpTexture = SKTexture(
        rect: CGRect(
            x: 43.0/521.0,
            y: 48.0/175.0,
            width: 21.0/521.0,
            height: 39.0/175.0
        ),
        inTexture: TextureManager.retrieveTexture(GlobalConstants.ImageNames.agent)
    )
    static let agentRightTexture = SKTexture(
        rect: CGRect(
            x: 176.0/521.0,
            y: 87.0/175.0,
            width: 25.0/521.0,
            height: 39.0/175.0
        ),
        inTexture: TextureManager.retrieveTexture(GlobalConstants.ImageNames.agent)
    )
    static let agentLeftTexture = SKTexture(
        rect: CGRect(
            x: 175.0/521.0,
            y: 45.0/175.0,
            width: 25.0/521.0,
            height: 39.0/175.0
        ),
        inTexture: TextureManager.retrieveTexture(GlobalConstants.ImageNames.agent)
    )
    static let agentDownTexture = SKTexture(
        rect: CGRect(
            x: 43.0/521.0,
            y: 88.0/175.0,
            width: 21.0/521.0,
            height: 39.0/175.0
        ),
        inTexture: TextureManager.retrieveTexture(GlobalConstants.ImageNames.agent)
    )
    static let monsterDownTexture = SKTexture(
        rect: CGRect(
            x: 0.0,
            y: 167.0/449.0,
            width: 48.0/712.0,
            height: 47.0/449.0
            ),
        inTexture: TextureManager.retrieveTexture(GlobalConstants.ImageNames.agent)
    )
    static let monsterUpTexture = SKTexture(
        rect: CGRect(
            x: 0.0,
            y: 227.0/449.0,
            width: 48.0/712.0,
            height: 47.0/449.0
        ),
        inTexture: TextureManager.retrieveTexture(GlobalConstants.ImageNames.monster)
    )
    static let monsterRightTexture = SKTexture(
        rect: CGRect(
            x: 8.0/712.0,
            y: 331.0/449.0,
            width: 48.0/712.0,
            height: 47.0/449.0
        ),
        inTexture: TextureManager.retrieveTexture(GlobalConstants.ImageNames.monster)
    )
    static let monsterSleepingTexture = SKTexture(
        rect: CGRect(
            x: 370.0/712.0,
            y: 167.0/449.0,
            width: 48.0/712.0,
            height: 47.0/449.0
        ),
        inTexture: TextureManager.retrieveTexture(GlobalConstants.ImageNames.monster)
    )
}
