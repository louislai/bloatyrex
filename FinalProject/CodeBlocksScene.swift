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
    let whileButton = BlockButton(imageNamed: "wall", blockType:  BlockType.While, blockCategory: BlockCategory.Action)
    let eyesButton = BlockButton(imageNamed: "eyes", blockType: BlockType.Eyes, blockCategory: BlockCategory.BoolOp)
    let toiletButton = BlockButton(imageNamed: "toilet", blockType: BlockType.Toilet, blockCategory: BlockCategory.Object)
    let holeButton = BlockButton(imageNamed: "hole", blockType: BlockType.Hole, blockCategory: BlockCategory.Object)
    let wallButton = BlockButton(imageNamed: "wall", blockType: BlockType.Wall, blockCategory: BlockCategory.Object)
    let woodButton = BlockButton(imageNamed: "wooden-block", blockType: BlockType.Wood, blockCategory: BlockCategory.Object)
    let ifButton = BlockButton(imageNamed: "trash", blockType: BlockType.If, blockCategory: BlockCategory.Action)
    private var programBlocks = ProgramBlocks()
    var heldBlock: BlockButton?
    var movedBlock: MovableBlockProtocol?
    var pressState = PressState.Idle

    let insertionPosition = InsertionPosition()

    func retrieveProgram() -> Program? {
        return programBlocks.getCode()
    }

    func getProgramBlocks() -> ProgramBlocks {
        return programBlocks
    }

    func setProgramBlocks(blocks: ProgramBlocks) {
        programBlocks.removeFromParent()
        programBlocks = blocks
        programBlocks.removeFromParent()
        addNodeToContent(programBlocks)
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        backgroundColor = SKColor.whiteColor()
        upButton.position = CGPoint(x: size.width * -0.1, y: size.height * 0.3)
        turnLeftButton.position = CGPoint(x: size.width * -0.3, y: size.height * 0.3)
        turnRightButton.position = CGPoint(x: size.width * -0.3, y: size.height * 0.2)
        whileButton.position = CGPoint(x: size.width * -0.1, y: size.height * 0.1)
        ifButton.position = CGPoint(x: size.width * -0.3, y: size.height * 0.1)
        eyesButton.position = CGPoint(x: size.width * -0.3, y: 0)
        toiletButton.position = CGPoint(x: size.width * -0.1, y: size.height * -0.1)
        wallButton.position = CGPoint(x: size.width * -0.3, y: size.height * -0.1)
        holeButton.position = CGPoint(x: size.width * -0.1, y: size.height * -0.2)
        woodButton.position = CGPoint(x: size.width * -0.3, y: size.height * -0.2)
        programBlocks.position = CGPoint(x: size.width * 0.5, y: size.height * 0.9)
        turnLeftButton.zPosition = 10
        upButton.zPosition = 10
        addNodeToOverlay(toiletButton)
        addNodeToOverlay(wallButton)
        addNodeToOverlay(holeButton)
        addNodeToOverlay(woodButton)
        addNodeToOverlay(turnLeftButton)
        addNodeToOverlay(whileButton)
        addNodeToOverlay(upButton)
        addNodeToOverlay(eyesButton)
        addNodeToOverlay(turnRightButton)
        addNodeToOverlay(ifButton)
        addNodeToContent(programBlocks)
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
        } else if whileButton.containsPoint(locationInOverlay) {
            heldBlock = whileButton
            whileButton.pickBlock(true)
            pressState = .AddingBlock(whileButton.blockCategory)
        } else if ifButton.containsPoint(locationInOverlay) {
            heldBlock = ifButton
            ifButton.pickBlock(true)
            pressState = .AddingBlock(ifButton.blockCategory)
        } else if eyesButton.containsPoint(locationInOverlay) {
            heldBlock = eyesButton
            eyesButton.pickBlock(true)
            pressState = .AddingBlock(eyesButton.blockCategory)
        } else if toiletButton.containsPoint(locationInOverlay) {
            heldBlock = toiletButton
            toiletButton.pickBlock(true)
            pressState = .AddingBlock(toiletButton.blockCategory)
        } else if wallButton.containsPoint(locationInOverlay) {
            heldBlock = wallButton
            wallButton.pickBlock(true)
            pressState = .AddingBlock(wallButton.blockCategory)
        } else if holeButton.containsPoint(locationInOverlay) {
            heldBlock = holeButton
            holeButton.pickBlock(true)
            pressState = .AddingBlock(holeButton.blockCategory)
        } else if woodButton.containsPoint(locationInOverlay) {
            heldBlock = woodButton
            woodButton.pickBlock(true)
            pressState = .AddingBlock(woodButton.blockCategory)
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
                        programBlocks.hover(touchLocation, category: block.category, insertionHandler: insertionPosition)
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
                    case .If:
                        insertionContainer.insertBlock(IfBlock(containingBlock: insertionContainer), insertionPosition: insertionPosition)
                    case .Eyes:
                        if let zone = insertionPosition.zone {
                            zone.insertBlock(SeeBlock(containingBlock: insertionContainer, containingZone: zone))
                        }
                    case .Toilet:
                        if let zone = insertionPosition.zone {
                            zone.insertObjectBlock(ToiletBlock(containingBlock: insertionContainer, containingZone: zone))
                        }
                    case .Hole:
                        if let zone = insertionPosition.zone {
                            zone.insertObjectBlock(HoleBlock(containingBlock: insertionContainer, containingZone: zone))
                        }
                    case .Wall:
                        if let zone = insertionPosition.zone {
                            zone.insertObjectBlock(WallBlock(containingBlock: insertionContainer, containingZone: zone))
                        }
                    case .Wood:
                        if let zone = insertionPosition.zone {
                            zone.insertObjectBlock(WoodBlock(containingBlock: insertionContainer, containingZone: zone))
                        }
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
                    switch block.category {
                    case .Action:
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
                                if let codeBlock = block as? CodeBlock {
                                    container.insertBlock(codeBlock, insertionPosition: insertionPosition)
                                }
                            }
                        }
                    case .BoolOp:
                        if let boolOpBlock = block as? BoolOpBlock {
                            boolOpBlock.containingZone.removeBoolOp()
                            boolOpBlock.removeFromParent()
                            if let zone = insertionPosition.zone {
                                zone.insertBlock(boolOpBlock)
                            }
                        }
                    case .Object:
                        if let objectBlock = block as? ObjectBlock {
                            objectBlock.containingZone.removeObject()
                            objectBlock.removeFromParent()
                            if let zone = insertionPosition.zone {
                                zone.insertObjectBlock(objectBlock)
                            }
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
