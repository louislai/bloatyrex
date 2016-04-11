//
//  IfBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 7/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

//
//  WhileBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 31/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class IfBlock: CodeBlock {
    let nestingDepth: CGFloat = 20
    let topBlock: SKSpriteNode
    let ifTrueBlock = NestingZone()
    let ifTrueDropZone: DropZone
    let elseBlock = NestingZone()
    let elseDropZone: DropZone
    let middleBlock: SKSpriteNode
    let bottomBlock: SKSpriteNode
    let boolOpZone: DropZone

    override func getBlockConstruct() -> Construct {
        if let predicate = boolOpZone.getBlockPredicate() {
            if let ifProgram = ifTrueBlock.parseBlock(0) {
                if let elseProgram = elseBlock.parseBlock(0) {
                    return Construct.ConditionalExpressionConstruct(ConditionalExpression.IfThenElseExpression(predicate, ifProgram, elseProgram))
                }
            }
        }
        return Construct.None
    }

    override var boolOpZones: [DropZone] {
        get {
            let result = getNestedBoolOpZones() + [boolOpZone]
            return result
        }
    }

    override var objectDropZones: [DropZone] {
        get {
            return boolOpZone.objectZones
        }
    }

    override var actionZones: [DropZone] {
        get {
            if dropZoneActivated {
                let result = [dropZone, ifTrueDropZone, elseDropZone] +
                    ifTrueBlock.dropZones + elseBlock.dropZones
                return result
            } else {
                return []
            }
        }
    }

    private func getNestedBoolOpZones() -> [DropZone] {
        var zones = [DropZone]()
        for block in ifTrueBlock.blocks {
            zones.appendContentsOf(block.boolOpZones)
        }
        return zones
    }

    override init(containingBlock: ContainerBlockProtocol) {
        middleBlock = SKSpriteNode(imageNamed: "trash")
        topBlock = SKSpriteNode(imageNamed: "trash")
        bottomBlock = SKSpriteNode(imageNamed: "trash")
        topBlock.size = CGSize(width: 64, height: 64)
        middleBlock.size = CGSize(width: 64, height: 64)
        bottomBlock.size = CGSize(width: 64, height: 64)
        ifTrueDropZone = DropZone(size: CGSize(width: 64, height: CodeBlock.dropZoneSize),
                                  dropZoneCategory: BlockCategory.Action,
                                  containingBlock: ifTrueBlock)
        elseDropZone = DropZone(size: CGSize(width: 64, height: CodeBlock.dropZoneSize),
                                dropZoneCategory: BlockCategory.Action,
                                containingBlock: elseBlock)
        boolOpZone = DropZone(size: CGSize(width: CodeBlock.dropZoneSize, height: topBlock.size.height),
                              dropZoneCategory: BlockCategory.BoolOp,
                              containingBlock: containingBlock)
        super.init(containingBlock: containingBlock)
        self.addChild(topBlock)
        self.addChild(ifTrueDropZone)
        self.addChild(ifTrueBlock)
        self.addChild(elseDropZone)
        self.addChild(elseBlock)
        self.addChild(middleBlock)
        self.addChild(bottomBlock)
        self.addChild(boolOpZone)
        flushBlocks()
        self.resizeDropZone()
    }

    override func endHover() {
        super.endHover()
        self.unfocus()
        ifTrueBlock.unfocus()
    }

    override func flushBlocks() {
        ifTrueBlock.flushBlocks()
        elseBlock.flushBlocks()
        if ifTrueBlock.count > 0 || elseBlock.count > 0 {
            let nestedBlocksFrame = ifTrueBlock.calculateAccumulatedFrame()
            let elseBlockFrame = elseBlock.calculateAccumulatedFrame()
            ifTrueBlock.position.x = nestingDepth
            elseBlock.position.x = nestingDepth

            topBlock.position = CGPoint(x: topBlock.size.width / 2,
                                        y: 5 * topBlock.size.height / 2 +
                                            3 * CodeBlock.dropZoneSize + nestedBlocksFrame.height +
                                            elseBlockFrame.height)
            middleBlock.position = CGPoint(x: topBlock.size.width / 2,
                                           y: 3 * topBlock.size.height / 2 +
                                            2 * CodeBlock.dropZoneSize + elseBlockFrame.height)
            bottomBlock.position = CGPoint(x: topBlock.size.width / 2,
                                           y: topBlock.size.height / 2 + CodeBlock.dropZoneSize)

            boolOpZone.position = CGPoint(x: topBlock.size.width,
                                          y: 2 * topBlock.size.height +
                                            3 * CodeBlock.dropZoneSize + nestedBlocksFrame.height +
                                            elseBlockFrame.height)

            ifTrueDropZone.position = CGPoint(x: nestingDepth, y: 2 * topBlock.size.height +
                2 * CodeBlock.dropZoneSize + nestedBlocksFrame.height + elseBlockFrame.height)
            ifTrueBlock.position.y = 2 * topBlock.size.height + nestedBlocksFrame.height +
                2 * CodeBlock.dropZoneSize + elseBlockFrame.height

            elseDropZone.position = CGPoint(x: nestingDepth, y: topBlock.size.height +
                CodeBlock.dropZoneSize + elseBlockFrame.height)
            elseBlock.position.y = topBlock.size.height + elseBlockFrame.height +
                CodeBlock.dropZoneSize
        } else {
            bottomBlock.position = CGPoint(x: topBlock.size.width / 2,
                                          y: topBlock.size.height / 2 + CodeBlock.dropZoneSize)
            middleBlock.position = CGPoint(x: topBlock.size.width / 2,
                                           y: 3 * topBlock.size.height / 2 +
                                            2 * CodeBlock.dropZoneSize)
            topBlock.position = CGPoint(x: topBlock.size.width / 2,
                                        y: 5 * topBlock.size.height / 2 +
                                            3 * CodeBlock.dropZoneSize)
            boolOpZone.position = CGPoint(x: topBlock.size.width, y: 2 * topBlock.size.height +
                3 * CodeBlock.dropZoneSize)
            ifTrueDropZone.position = CGPoint(x: nestingDepth, y: 2 * topBlock.size.height +
                2 * CodeBlock.dropZoneSize)
            ifTrueBlock.position = CGPoint(x: nestingDepth, y: 2 * topBlock.size.height +
                3 * CodeBlock.dropZoneSize)
            elseDropZone.position = CGPoint(x: nestingDepth, y: topBlock.size.height + CodeBlock.dropZoneSize)
            elseBlock.position = CGPoint(x: nestingDepth, y: topBlock.size.height +
                2 * CodeBlock.dropZoneSize)
        }
    }

    override func activateDropZone() {
        super.activateDropZone()
        ifTrueDropZone.hidden = false
        ifTrueBlock.activateDropZones()
        elseDropZone.hidden = false
        elseBlock.activateDropZones()
    }

    override func deactivateDropZone() {
        super.deactivateDropZone()
        ifTrueDropZone.hidden = true
        ifTrueBlock.deactivateDropZones()
        elseDropZone.hidden = true
        elseBlock.deactivateDropZones()
    }

    override func unfocus() {
        super.unfocus()
        ifTrueDropZone.displayNormal()
        ifTrueBlock.unfocus()
        elseDropZone.displayNormal()
        elseBlock.unfocus()
    }

    override func getBlock(location: CGPoint) -> MovableBlockProtocol? {
        let xLocation = location.x - self.position.x
        let yLocation = location.y - self.position.y
        let correctedLocation = CGPoint(x: xLocation, y: yLocation)
        if ifTrueBlock.containsPoint(correctedLocation) {
            return ifTrueBlock.getBlock(correctedLocation)
        } else if elseBlock.containsPoint(correctedLocation) {
            return elseBlock.getBlock(correctedLocation)
        } else if boolOpZone.containsPoint(correctedLocation) {
            return boolOpZone.getBlock(correctedLocation)
        } else {
            return self
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
