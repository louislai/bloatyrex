//
//  CodeBlocksScene.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 15/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class CodeBlocksScene: SKScene {
    
    let testObject = SKSpriteNode(imageNamed: "toilet")
    let blockButton = SKSpriteNode(imageNamed: "toilet")
    
    let dropZone = DropZone(size: CGSizeMake(100, 50))
    var holdingItem = false
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        blockButton.position = CGPointMake(size.width * 0.1, size.height * 0.5)
        dropZone.position = CGPointMake(size.width * 0.9, size.height * 0.5)
        addChild(dropZone)
        addChild(blockButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(self)
        
        if blockButton.containsPoint(location) {
            testObject.position = CGPointMake(size.width * 0.1, size.height * 0.5)
            addChild(testObject)
            holdingItem = true
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        let previousLocation = touch.previousLocationInNode(self)
        
        let newX = testObject.position.x + touchLocation.x - previousLocation.x
        let newY = testObject.position.y + touchLocation.y - previousLocation.y
        
        testObject.position = CGPointMake(newX, newY)
        
        if holdingItem && dropZone.containsPoint(touchLocation) {
            dropZone.displayHover()
        } else {
            dropZone.displayNormal()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        testObject.removeFromParent()
        holdingItem = false
        dropZone.displayNormal()
    }
}
