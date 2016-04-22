//
//  AgentNodeConstants.swift
//  BloatyRex
//
//  Created by louis on 19/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

struct AgentNodeConstants {
    static let timePerMoveMovement: NSTimeInterval = 0.6
    static let timePerFrame: NSTimeInterval = 0.1
    static let defaultNumberOfMoves = 30
    static let walkingUpTextures = [
        SKTexture(
            rect: CGRect(
                x: 22.0/521.0,
                y: 48.0/175.0,
                width: 21.0/521.0,
                height: 39.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        ),
        SKTexture(
            rect: CGRect(
                x: 64.0/521.0,
                y: 48.0/175.0,
                width: 21.0/521.0,
                height: 39.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        )
    ]
    static let walkingRightTextures = [
        SKTexture(
            rect: CGRect(
                x: 149.0/521.0,
                y: 87.0/175.0,
                width: 25.0/521.0,
                height: 39.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        ),
        SKTexture(
            rect: CGRect(
                x: 203.0/521.0,
                y: 87.0/175.0,
                width: 25.0/521.0,
                height: 39.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        )
    ]
    static let walkingLeftTextures = [
        SKTexture(
            rect: CGRect(
                x: 148.0/521.0,
                y: 45.0/175.0,
                width: 25.0/521.0,
                height: 39.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        ),
        SKTexture(
            rect: CGRect(
                x: 202.0/521.0,
                y: 45.0/175.0,
                width: 25.0/521.0,
                height: 39.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        )
    ]
    static let walkingDownTextures = [
        SKTexture(
            rect: CGRect(
                x: 22.0/521.0,
                y: 88.0/175.0,
                width: 21.0/521.0,
                height: 39.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        ),
        SKTexture(
            rect: CGRect(
                x: 64.0/521.0,
                y: 88.0/175.0,
                width: 21.0/521.0,
                height: 39.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        )
    ]
    static let winningTextures = [
        SKTexture(
            rect: CGRect(
                x: 417.0/521.0,
                y: 47.0/175.0,
                width: 29.0/521.0,
                height: 40.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        ),
        SKTexture(
            rect: CGRect(
                x: 484.0/521.0,
                y: 47.0/175.0,
                width: 29.0/521.0,
                height: 40.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        )
    ]
    static let losingTextures = [
        SKTexture(
            rect: CGRect(
                x: 270.0/521.0,
                y: 47.0/175.0,
                width: 29.0/521.0,
                height: 40.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        ),
        SKTexture(
            rect: CGRect(
                x: 271.0/521.0,
                y: 87.0/175.0,
                width: 25.0/521.0,
                height: 39.0/175.0
            ),
            inTexture: TextureManager.retrieveTexture("agent")
        )
    ]
}
