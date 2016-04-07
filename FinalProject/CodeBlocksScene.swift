//
//  CodeBlocksScene.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 15/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class CodeBlocksScene: PannableScene, ProgramSupplier {

    enum PressState {
        case AddingBlock(BlockCategory)
        case MovingBlock
        case Idle
    }

    let upButton = BlockButton(imageNamed: "up-block", blockType: BlockType.Forward, blockCategory: BlockCategory.Action)
    let turnLeftButton = BlockButton(imageNamed: "turn-left-block", blockType: BlockType.TurnLeft, blockCategory: BlockCategory.Action)
    let turnRightButton = BlockButton(imageNamed: "turn-right-block", blockType: BlockType.TurnRight, blockCategory: BlockCategory.Action)
    let nestButton = BlockButton(imageNamed: "wall", blockType:  BlockType.While, blockCategory: BlockCategory.Action)
    let eyesButton = BlockButton(imageNamed: "eyes", blockType: BlockType.Eyes, blockCategory: BlockCategory.BoolOp)
    let toiletButton = BlockButton(imageNamed: "toilet", blockType: BlockType.Toilet, blockCategory: BlockCategory.Object)
    let programBlocks = ProgramBlocks()
    var heldBlock: BlockButton?
    var movedBlock: CodeBlock?
    var pressState = PressState.Idle

    let insertionPosition = InsertionPosition()

    func retrieveProgram() -> Program? {
        return programBlocks.getCode()
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        backgroundColor = SKColor.whiteColor()
        turnRightButton.position = CGPoint(x: size.width * -0.3, y: size.height * 0.3)
        upButton.position = CGPoint(x: size.width * -0.3, y: size.height * 0.2)
        turnLeftButton.position = CGPoint(x: size.width * -0.3, y: size.height * 0.1)
        nestButton.position = CGPoint(x: size.width * -0.3, y: size.height * 0.4)
        eyesButton.position = CGPoint(x: size.width * -0.3, y: 0)
        toiletButton.position = CGPoint(x: size.width * -0.3, y: size.height * -0.1)
        programBlocks.position = CGPoint(x: size.width * 0.5, y: size.height * 0.9)
        turnLeftButton.zPosition = 10
        upButton.zPosition = 10
        addNodeToOverlay(toiletButton)
        addNodeToOverlay(turnLeftButton)
        addNodeToOverlay(nestButton)
        addNodeToOverlay(upButton)
        addNodeToOverlay(eyesButton)
        addNodeToContent(programBlocks)
        addNodeToOverlay(turnRightButton)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let locationInOverlay = touch.locationInNode(overlay)
        let locationInContent = touch.locationInNode(content)

        if upButton.containsPoint(locationInOverlay) {
            heldBlock = upButton
            upButton.pickBlock(true)
            pressState = .AddingBlock(upButton.blockCategory)
        } else if turnLeftButton.containsPoint(locationInOverlay) {
            heldBlock = turnLeftButton
            turnLeftButton.pickBlock(true)
            pressState = .AddingBlock(turnLeftButton.blockCategory)
        } else if turnRightButton.containsPoint(locationInOverlay) {
            heldBlock = turnRightButton
            turnRightButton.pickBlock(true)
            pressState = .AddingBlock(turnRightButton.blockCategory)
        } else if nestButton.containsPoint(locationInOverlay) {
            heldBlock = nestButton
            nestButton.pickBlock(true)
            pressState = .AddingBlock(nestButton.blockCategory)
        } else if eyesButton.containsPoint(locationInOverlay) {
            heldBlock = eyesButton
            eyesButton.pickBlock(true)
            pressState = .AddingBlock(eyesButton.blockCategory)
        } else if toiletButton.containsPoint(locationInOverlay) {
            heldBlock = toiletButton
            toiletButton.pickBlock(true)
            pressState = .AddingBlock(toiletButton.blockCategory)
        }

        if programBlocks.containsPoint(locationInContent) {
            movedBlock = programBlocks.getBlock(locationInContent)
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
        case .AddingBlock(let category):
            if let block = heldBlock {
                block.moveBlock(CGPoint(x: xMovement, y: yMovement))
                if programBlocks.containsPoint(touchLocation) {
                    programBlocks.hover(touchLocation, category: category, insertionHandler: insertionPosition)
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
                        programBlocks.hover(touchLocation, category: BlockCategory.Action, insertionHandler: insertionPosition)
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
                print(insertionPosition.container)
                if let insertionContainer = insertionPosition.container {
                    switch block.blockType {
                    case .Forward:
                        insertionContainer.insertBlock(ForwardBlock(containingBlock: insertionContainer), insertionPosition: insertionPosition)
                    case .TurnLeft:
                        insertionContainer.insertBlock(TurnLeftBlock(containingBlock: insertionContainer), insertionPosition: insertionPosition)
                    case .TurnRight:
                        insertionContainer.insertBlock(TurnRightBlock(containingBlock: insertionContainer), insertionPosition: insertionPosition)
                    case .While:
                        insertionContainer.insertBlock(WhileBlock(containingBlock: insertionContainer), insertionPosition: insertionPosition)
                    case .Eyes:
                        if let zone = insertionPosition.zone {
                            zone.insertBlock(SeeBlock(containingBlock: insertionContainer))
                        }
                    case .Toilet:
                        break
                    default:
                        break
                    }
                }
                insertionPosition.position = nil
            }
            heldBlock = nil
        case .MovingBlock:
            if let block = movedBlock {
                if let _ = block as? MainBlock {

                } else {
                    block.activateDropZone()
                    programBlocks.endHover()
                    block.containingBlock.removeBlockAtIndex(block.blockPosition)
                    block.removeFromParent()
                    if let container = insertionPosition.container {
                        block.containingBlock = container
                        if let position = insertionPosition.position {
                            if block.containingBlock === container && position > block.blockPosition {
                                insertionPosition.position = position - 1
                            }
                            container.insertBlock(block, insertionPosition: insertionPosition)
                        }
                    }
                }
            }
            movedBlock = nil
        case .Idle:
            break
        }
        programBlocks.flushBlocks()
        pressState = .Idle
    }
}
