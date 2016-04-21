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
    let objectSection = BlocksSection(title: "Objects", color: GlobalConstants.Font.defaultGreen)

    let upButton = BlockButton(
        imageNamed: GlobalConstants.ImageNames.move_block,
        blockCategory: BlockCategory.Action,
        action: ActionBlock.getForwardBlock)
    let turnLeftButton = BlockButton(
        imageNamed: GlobalConstants.ImageNames.rotate_left_block,
        blockCategory: BlockCategory.Action,
        action: ActionBlock.getTurnLeftBlock)
    let turnRightButton = BlockButton(
        imageNamed: GlobalConstants.ImageNames.rotate_right_block,
        blockCategory: BlockCategory.Action,
        action: ActionBlock.getTurnRightBlock)
    let waitButton = BlockButton(
        imageNamed: GlobalConstants.ImageNames.wait_block,
        blockCategory: BlockCategory.Action,
        action: ActionBlock.getWaitBlock)
    let jumpButton = BlockButton(
        imageNamed: GlobalConstants.ImageNames.jump_block,
        blockCategory: BlockCategory.Action,
        action: ActionBlock.getJumpBlock)
    let pressRedButton = BlockButton(
        imageNamed: GlobalConstants.ImageNames.press_left_block,
        blockCategory: BlockCategory.Action,
        action: ActionBlock.getPressRedBlock)
    let pressBlueButton = BlockButton(
        imageNamed: GlobalConstants.ImageNames.press_right_block,
        blockCategory: BlockCategory.Action,
        action: ActionBlock.getPressBlueBlock)
    let whileButton = BlockButton(
        imageNamed: GlobalConstants.ImageNames.while_block,
        blockCategory: BlockCategory.Action,
        action: WhileBlock.init)
    let ifButton = BlockButton(
        imageNamed: GlobalConstants.ImageNames.if_else_block,
        blockCategory: BlockCategory.Action,
        action: IfBlock.init)
    let eyesButton = BlockButton(
        imageNamed: GlobalConstants.ImageNames.see_block,
        blockCategory: BlockCategory.BoolOp,
        boolOp: SeeBlock.init)
    let notButton = BlockButton(
        imageNamed: GlobalConstants.ImageNames.not_block,
        blockCategory: BlockCategory.BoolOp,
        boolOp: NotBlock.init)
    let notSafeButton = BlockButton(
        imageNamed: GlobalConstants.ImageNames.not_safe_block,
        blockCategory: BlockCategory.BoolOp,
        boolOp: NotSafeBlock.init)
    let toiletButton = BlockButton(
        imageNamed: GlobalConstants.ImageNames.goal,
        blockCategory: BlockCategory.Object,
        object: ObjectBlock.getToiletBlock)
    let holeButton = BlockButton(
        imageNamed: GlobalConstants.ImageNames.hole,
        blockCategory: BlockCategory.Object,
        object: ObjectBlock.getHoleBlock)
    let wallButton = BlockButton(
        imageNamed: GlobalConstants.ImageNames.wall,
        blockCategory: BlockCategory.Object,
        object: ObjectBlock.getWallBlock)
    let woodButton = BlockButton(
        imageNamed: GlobalConstants.ImageNames.wooden_block,
        blockCategory: BlockCategory.Object,
        object: ObjectBlock.getWoodBlock)
    let leftCorrectButton = BlockButton(
        imageNamed: GlobalConstants.ImageNames.buttons_left,
        blockCategory: BlockCategory.Object,
        object: ObjectBlock.getLeftDoorBlock)
    let rightCorrectButton = BlockButton(
        imageNamed: GlobalConstants.ImageNames.buttons_right,
        blockCategory: BlockCategory.Object,
        object: ObjectBlock.getRightDoorBlock)
    let emptySpaceButton = BlockButton(
        imageNamed: GlobalConstants.ImageNames.space,
        blockCategory: BlockCategory.Object,
        object: ObjectBlock.getEmptySpaceBlock
    )
    let monsterButton = BlockButton(
        imageNamed: GlobalConstants.ImageNames.monster_static,
        blockCategory: BlockCategory.Object,
        object: ObjectBlock.getMonsterBlock)
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
            programBlocks.position = CGPoint(x: size.width * 0.1, y: size.height)
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
                block.zPosition = 10
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
                    switch block.blockCategory {
                    case .Action:
                        if let action = block.getAction(insertionContainer) {
                            insertionContainer.insertBlock(action, insertionPosition: insertionPosition)
                        }
                    case .BoolOp:
                        if let zone = insertionPosition.zone, boolOp = block.getBoolOp(insertionContainer, zone: zone) {
                            zone.insertBlock(boolOp)
                        }
                    case .Object:
                        if let zone = insertionPosition.zone, object = block.getObject(insertionContainer, zone: zone) {
                            zone.insertObjectBlock(object)
                        }
                    }
                }
                insertionPosition.position = nil
            }
            heldBlock = nil
        case .MovingBlock:
            if let block = movedBlock {
                block.zPosition = 0
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
