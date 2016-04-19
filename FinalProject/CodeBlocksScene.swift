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

    let actionSection = BlocksSection(title: "Actions", color: SKColor.redColor())
    let controlSection = BlocksSection(title: "Control", color: SKColor.redColor())
    let conditionalSection = BlocksSection(title: "Conditionals", color: SKColor.purpleColor())
    let objectSection = BlocksSection(title: "Objects", color: SKColor.greenColor())
    let upButton = BlockButton(imageNamed: "up-block", blockType: BlockType.Forward, blockCategory: BlockCategory.Action)
    let turnLeftButton = BlockButton(imageNamed: "turn-left-block", blockType: BlockType.TurnLeft, blockCategory: BlockCategory.Action)
    let turnRightButton = BlockButton(imageNamed: "turn-right-block", blockType: BlockType.TurnRight, blockCategory: BlockCategory.Action)
    let waitButton = BlockButton(imageNamed: "wait-block", blockType: BlockType.Wait, blockCategory: BlockCategory.Action)
    let jumpButton = BlockButton(imageNamed: "jump-block", blockType: BlockType.Jump, blockCategory: BlockCategory.Action)
    let pressRedButton = BlockButton(imageNamed: "press-red-block", blockType: BlockType.PressRed, blockCategory: BlockCategory.Action)
    let pressBlueButton = BlockButton(imageNamed: "press-blue-block", blockType: BlockType.PressBlue, blockCategory: BlockCategory.Action)
    let whileButton = BlockButton(imageNamed: "wall", blockType:  BlockType.While, blockCategory: BlockCategory.Action)
    let eyesButton = BlockButton(imageNamed: "eyes", blockType: BlockType.Eyes, blockCategory: BlockCategory.BoolOp)
    let toiletButton = BlockButton(imageNamed: "toilet", blockType: BlockType.Toilet, blockCategory: BlockCategory.Object)
    let holeButton = BlockButton(imageNamed: "hole", blockType: BlockType.Hole, blockCategory: BlockCategory.Object)
    let wallButton = BlockButton(imageNamed: "wall", blockType: BlockType.Wall, blockCategory: BlockCategory.Object)
    let woodButton = BlockButton(imageNamed: "wooden-block", blockType: BlockType.Wood, blockCategory: BlockCategory.Object)
    let ifButton = BlockButton(imageNamed: "trash", blockType: BlockType.If, blockCategory: BlockCategory.Action)
    let notButton = BlockButton(imageNamed: "not-block", blockType: BlockType.Not, blockCategory: BlockCategory.BoolOp)
    let notSafeButton = BlockButton(imageNamed: "not-safe-block", blockType: BlockType.Safe, blockCategory: BlockCategory.BoolOp)
    let leftCorrectButton = BlockButton(imageNamed: "buttons-left", blockType: BlockType.LeftCorrect, blockCategory: BlockCategory.Object)
    let rightCorrectButton = BlockButton(imageNamed: "buttons-right", blockType: BlockType.RightCorrect, blockCategory: BlockCategory.Object)
    let emptySpaceButton = BlockButton(imageNamed: "space", blockType: BlockType.Empty, blockCategory: BlockCategory.Object)
    let monsterButton = BlockButton(imageNamed: "monster-static", blockType: BlockType.Monster, blockCategory: BlockCategory.Object)
    let trashZone = TrashZone()
    private var programBlocks = ProgramBlocks()
    var heldBlock: BlockButton?
    var movedBlock: MovableBlockProtocol?
    var pressState = PressState.Idle
    var editEnabled = false
    var programBlockFrame: CGRect?

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
        if editEnabled {
            programBlocks.position = CGPoint(x: size.width * -0.1, y: size.height)
        } else {
            programBlocks.position = CGPoint(x: size.width * 0.1, y: size.height)
        }
        addNodeToContent(programBlocks)
    }

    override func resetOtherTouches() {
        programBlocks.endHover()
        trashZone.unfocus()
        if let block = heldBlock {
            block.pickBlock(false, scale: getScale())
        }
        if let block = movedBlock {
            block.activateDropZone()
        }
        heldBlock = nil
        movedBlock = nil
        programBlocks.flushBlocks()
    }

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        backgroundColor = UIColor.groupTableViewBackgroundColor()
        if editEnabled {
            trashZone.position = CGPoint(x: size.width * -0.15, y: size.height * -0.45)

            addNodeToOverlay(trashZone)
            
            let blockSectionsX = self.frame.width / 2 - GlobalConstants.CodeBlocks.blockSectionWidth
            let actionSectionY = self.frame.height / 2 - GlobalConstants.CodeBlocks.blockSectionTitleHeight
            actionSection.position = CGPoint(x: blockSectionsX, y: actionSectionY)
            addNodeToOverlay(actionSection)
            actionSection.addButton(upButton)
            actionSection.addButton(turnLeftButton)
            actionSection.addButton(turnRightButton)
            actionSection.addButton(waitButton)
            actionSection.addButton(pressRedButton)
            actionSection.addButton(pressBlueButton)
            actionSection.addButton(jumpButton)
            
            let actionSectionFrame = actionSection.calculateAccumulatedFrame()
            let controlSectionY = -actionSectionFrame.height + actionSectionY - GlobalConstants.CodeBlocks.blockSectionMargin
            controlSection.position = CGPoint(x: blockSectionsX, y: controlSectionY)
            addNodeToOverlay(controlSection)
            controlSection.addButton(whileButton)
            controlSection.addButton(ifButton)
            
            let controlSectionFrame = controlSection.calculateAccumulatedFrame()
            let conditionalSectionY = -controlSectionFrame.height + controlSectionY - GlobalConstants.CodeBlocks.blockSectionMargin
            conditionalSection.position = CGPoint(x: blockSectionsX, y: conditionalSectionY)
            addNodeToOverlay(conditionalSection)
            conditionalSection.addButton(eyesButton)
            conditionalSection.addButton(notButton)
            conditionalSection.addButton(notSafeButton)
            
            let conditionalSectionFrame = conditionalSection.calculateAccumulatedFrame()
            let objectSectionY = -conditionalSectionFrame.height + conditionalSectionY - GlobalConstants.CodeBlocks.blockSectionMargin
            objectSection.position = CGPoint(x: blockSectionsX, y: objectSectionY)
            addNodeToOverlay(objectSection)
            objectSection.addButton(toiletButton)
            objectSection.addButton(wallButton)
            objectSection.addButton(emptySpaceButton)
            objectSection.addButton(monsterButton)
            objectSection.addButton(woodButton)
            objectSection.addButton(holeButton)
            objectSection.addButton(leftCorrectButton)
            objectSection.addButton(rightCorrectButton)
        }
        programBlocks.position = CGPoint(x: size.width * 0.3, y: size.height)
        addNodeToContent(programBlocks)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !editEnabled {
            return
        }
        let touch = touches.first! as UITouch
        let locationInOverlay = touch.locationInNode(overlay)
        let locationInContent = touch.locationInNode(content)
        let scale = 1/getScale()
        
        if actionSection.containsPoint(locationInOverlay) {
            heldBlock = actionSection.getButton(locationInOverlay)
        } else if controlSection.containsPoint(locationInOverlay) {
            heldBlock = controlSection.getButton(locationInOverlay)
        } else if conditionalSection.containsPoint(locationInOverlay) {
            heldBlock = conditionalSection.getButton(locationInOverlay)
        } else if objectSection.containsPoint(locationInOverlay) {
            heldBlock = objectSection.getButton(locationInOverlay)
        }

        if let block = heldBlock {
            pressState = .AddingBlock(block.blockCategory)
            block.pickBlock(true, scale: scale)
        }
        

        if programBlocks.containsPoint(locationInContent) {
            movedBlock = programBlocks.getBlock(locationInContent)
            if let block = movedBlock {
                block.deactivateDropZone()
                pressState = .MovingBlock
            }

            programBlockFrame = programBlocks.calculateAccumulatedFrame()
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !editEnabled {
            return
        }
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        let previousLocation = touch.previousLocationInNode(self)
        var xMovement = (touchLocation.x - previousLocation.x)
        var yMovement = (touchLocation.y - previousLocation.y)
        trashZone.unfocus()
        programBlocks.endHover()

        switch pressState {
        case .AddingBlock(let category):
            if let block = heldBlock {
                xMovement *= (1/getScale())
                yMovement *= (1/getScale())
                block.moveBlock(CGPoint(x: xMovement, y: yMovement))
                if programBlocks.containsPoint(touchLocation) {
                    programBlocks.hover(touchLocation, category: category, insertionHandler: insertionPosition)
                } else {
                    trashZone.focus(insertionPosition)
                }
            }
        case .MovingBlock:
            if let block = movedBlock, frame = programBlockFrame {
                if let _ = block as? MainBlock {
                    programBlocks.shift(CGPoint(x: xMovement, y: yMovement))
                } else {
                    block.position.x += xMovement
                    block.position.y += yMovement
                    if frame.contains(touchLocation) {
                        programBlocks.hover(touchLocation, category: block.category, insertionHandler: insertionPosition)
                    } else {
                        trashZone.focus(insertionPosition)
                    }
                }
            }
        case .Idle:
            break
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !editEnabled {
            return
        }
        trashZone.unfocus()
        switch pressState {
        case .AddingBlock:
            if let block = heldBlock {
                block.dropBlock()
                programBlocks.endHover()
                if let insertionContainer = insertionPosition.container {
                    switch block.blockType {
                    case .Forward:
                        insertionContainer.insertBlock(ActionBlock.getForwardBlock(containingBlock: insertionContainer), insertionPosition: insertionPosition)
                    case .TurnLeft:
                        insertionContainer.insertBlock(ActionBlock.getTurnLeftBlock(containingBlock: insertionContainer), insertionPosition: insertionPosition)
                    case .TurnRight:
                        insertionContainer.insertBlock(ActionBlock.getTurnRightBlock(containingBlock: insertionContainer), insertionPosition: insertionPosition)
                    case .Wait:
                        insertionContainer.insertBlock(ActionBlock.getWaitBlock(containingBlock: insertionContainer), insertionPosition: insertionPosition)
                    case .Jump:
                        insertionContainer.insertBlock(ActionBlock.getJumpBlock(containingBlock: insertionContainer), insertionPosition: insertionPosition)
                    case .PressRed:
                        insertionContainer.insertBlock(ActionBlock.getPressRedBlock(containingBlock: insertionContainer), insertionPosition: insertionPosition)
                    case .PressBlue:
                        insertionContainer.insertBlock(ActionBlock.getPressBlueBlock(containingBlock: insertionContainer), insertionPosition: insertionPosition)
                    case .While:
                        insertionContainer.insertBlock(WhileBlock(containingBlock: insertionContainer), insertionPosition: insertionPosition)
                    case .If:
                        insertionContainer.insertBlock(IfBlock(containingBlock: insertionContainer), insertionPosition: insertionPosition)
                    case .Eyes:
                        if let zone = insertionPosition.zone {
                            zone.insertBlock(SeeBlock(containingBlock: insertionContainer, containingZone: zone))
                        }
                    case .Not:
                        if let zone = insertionPosition.zone {
                            zone.insertBlock(NotBlock(containingBlock: insertionContainer, containingZone: zone))
                        }
                    case .Safe:
                        if let zone = insertionPosition.zone {
                            zone.insertBlock(NotSafeBlock(containingBlock: insertionContainer, containingZone: zone))
                        }
                    case .Toilet:
                        if let zone = insertionPosition.zone {
                            zone.insertObjectBlock(ObjectBlock.getToiletBlock(containingBlock: insertionContainer, containingZone: zone))
                        }
                    case .Hole:
                        if let zone = insertionPosition.zone {
                            zone.insertObjectBlock(ObjectBlock.getHoleBlock(containingBlock: insertionContainer, containingZone: zone))
                        }
                    case .Wall:
                        if let zone = insertionPosition.zone {
                            zone.insertObjectBlock(ObjectBlock.getWallBlock(containingBlock: insertionContainer, containingZone: zone))
                        }
                    case .Wood:
                        if let zone = insertionPosition.zone {
                            zone.insertObjectBlock(ObjectBlock.getWoodBlock(containingBlock: insertionContainer, containingZone: zone))
                        }
                    case .RightCorrect:
                        if let zone = insertionPosition.zone {
                            zone.insertObjectBlock(ObjectBlock.getRightDoorBlock(containingBlock: insertionContainer, containingZone: zone))
                        }
                    case .LeftCorrect:
                        if let zone = insertionPosition.zone {
                            zone.insertObjectBlock(ObjectBlock.getLeftDoorBlock(containingBlock: insertionContainer, containingZone: zone))
                        }
                    case .Empty:
                        if let zone = insertionPosition.zone {
                            zone.insertObjectBlock(ObjectBlock.getEmptySpaceBlock(containingBlock: insertionContainer, containingZone: zone))
                        }
                    case .Monster:
                        if let zone = insertionPosition.zone {
                            zone.insertObjectBlock(ObjectBlock.getMonsterBlock(containingBlock: insertionContainer, containingZone: zone))
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
