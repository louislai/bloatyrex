//
//  CodeBlocksScene.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 15/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class CodeBlocksScene: SKScene {

    enum PressState {
        case AddingBlock
        case MovingBlock
        case Idle
    }

    let blockButton = BlockButton(imageNamed: "toilet", blockType: BlockType.Forward)
    let wallButton = BlockButton(imageNamed: "wall", blockType: BlockType.TurnLeft)
    let programBlocks = ProgramBlocks()
    var heldBlock: BlockButton?
    var movedBlock: CodeBlock?
    var pressState = PressState.Idle

    let insertionPosition = InsertionPosition()

    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        blockButton.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        wallButton.position = CGPoint(x: size.width * 0.1, y: size.height * 0.3)
        programBlocks.position = CGPoint(x: size.width * 0.4, y: size.height * 0.9)
        wallButton.zPosition = 10
        blockButton.zPosition = 10
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
            pressState = .AddingBlock
        } else if wallButton.containsPoint(location) {
            heldBlock = wallButton
            wallButton.pickBlock(true)
            pressState = .AddingBlock
        }

        if programBlocks.containsPoint(location) {
            movedBlock = programBlocks.getBlock(location)
            if let block = movedBlock {
                block.deactivateDropZone()
                pressState = .MovingBlock
            }
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        let previousLocation = touch.previousLocationInNode(self)
        let xMovement = touchLocation.x - previousLocation.x
        let yMovement = touchLocation.y - previousLocation.y

        switch pressState {
        case .AddingBlock:
            if let block = heldBlock {
                block.moveBlock(CGPoint(x: xMovement, y: yMovement))
                if programBlocks.containsPoint(touchLocation) {
                    programBlocks.hover(touchLocation, insertionHandler: insertionPosition)
                } else {
                    programBlocks.hover(touchLocation, insertionHandler: insertionPosition)
                }
            }
        case .MovingBlock:
            if let block = movedBlock {
                if let _ = block as? MainBlock {
                    programBlocks.shift(CGPoint(x: xMovement, y: yMovement))
                } else {
                    block.position.x += xMovement
                    block.position.y += yMovement
                    if programBlocks.containsPoint(touchLocation) {
                        programBlocks.hover(touchLocation, insertionHandler: insertionPosition)
                    } else {
                        programBlocks.hover(touchLocation, insertionHandler: insertionPosition)
                    }
                }
            }
        case .Idle:
            break
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        switch pressState {
        case .AddingBlock:
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
        case .MovingBlock:
            if let block = movedBlock {
                block.activateDropZone()
                programBlocks.endHover()
                programBlocks.reorderBlock(block, insertionHandler: insertionPosition)
            }
            movedBlock = nil
        case .Idle:
            break
        }
        pressState = .Idle
    }
}
