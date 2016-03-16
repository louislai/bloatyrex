//
//  CodeBlocksScene.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 15/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class CodeBlocksScene: SKScene {
    
    let blockButton = BlockButton(imageNamed: "toilet")
    
    let dropZone = DropZone(size: CGSizeMake(100, 50))
    var heldBlock: BlockButton?
    
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
            heldBlock = blockButton
            blockButton.pickBlock(true)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        let previousLocation = touch.previousLocationInNode(self)
        let xMovement = touchLocation.x - previousLocation.x
        let yMovement = touchLocation.y - previousLocation.y
        
        if let block = heldBlock {
            block.moveBlock(CGPointMake(xMovement, yMovement))
            if dropZone.containsPoint(touchLocation) {
                dropZone.displayHover()
            } else {
                dropZone.displayNormal()
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        dropZone.displayNormal()
        blockButton.pickBlock(false)
        heldBlock = nil
    }
}
