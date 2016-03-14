//
//  TextureManager.swift
//  FinalProject
//
//  Created by louis on 13/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

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
            x: 0.333,
            y: 0,
            width: 0.333,
            height: 0.25
        ),
        inTexture: TextureManager.retrieveTexture("agent")
    )
    static let agentRightTexture = SKTexture(
        rect: CGRect(
            x: 0.333,
            y: 0.25,
            width: 0.333,
            height: 0.25
        ),
        inTexture: TextureManager.retrieveTexture("agent")
    )
    static let agentLeftTexture = SKTexture(
        rect: CGRect(
            x: 0.333,
            y: 0.5,
            width: 0.333,
            height: 0.25
        ),
        inTexture: TextureManager.retrieveTexture("agent")
    )
    static let agentDownTexture = SKTexture(
        rect: CGRect(
            x: 0.333,
            y: 0.75,
            width: 0.333,
            height: 0.25
        ),
        inTexture: TextureManager.retrieveTexture("agent")
    )
}
