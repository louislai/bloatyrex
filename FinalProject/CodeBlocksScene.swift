//
//  CodeBlocksScene.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 15/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class CodeBlocksScene: SKScene {
    
    let blockButton = BlockButton(imageNamed: "toilet", blockType: BlockType.Forward)
    let wallButton = BlockButton(imageNamed: "wall", blockType: BlockType.TurnLeft)
    let programBlocks = ProgramBlocks()
    var heldBlock: BlockButton?
    
    let insertionPosition = InsertionPosition()
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        blockButton.position = CGPointMake(size.width * 0.1, size.height * 0.5)
        wallButton.position = CGPointMake(size.width * 0.1, size.height * 0.3)
        programBlocks.position = CGPointMake(size.width * 0.4, size.height * 0.9)
        addChild(wallButton)
        addChild(blockButton)
        addChild(programBlocks)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(self)
        
        if blockButton.containsPoint(location) {
            heldBlock = blockButton
            blockButton.pickBlock(true)
        } else if wallButton.containsPoint(location) {
            heldBlock = wallButton
            wallButton.pickBlock(true)
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
            if programBlocks.containsPoint(touchLocation) {
                programBlocks.hover(touchLocation, insertionHandler: insertionPosition)
            } else {
                programBlocks.hover(touchLocation, insertionHandler: insertionPosition)
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let block = heldBlock {
            block.pickBlock(false)
            programBlocks.endHover()
            switch block.blockType {
            case .Forward:
                programBlocks.insertBlock(ForwardBlock(), insertionHandler: insertionPosition)
            case .TurnLeft:
                programBlocks.insertBlock(TurnLeftBlock(), insertionHandler: insertionPosition)
            default:
                break
            }
            insertionPosition.position = nil
        }
        heldBlock = nil
    }
}
