//
//  WhileBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 31/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class WhileBlock: CodeBlock {
    let nestingDepth: CGFloat = 20
    let topBlock: SKSpriteNode
    let nestedBlocks = NestingZone()
    let nestedDropZone: DropZone
    let bottomBlock: SKSpriteNode
    let boolOpZone: DropZone

    override func getBlockConstruct() -> Construct {
        if let predicate = boolOpZone.getBlockPredicate() {
            if let program = nestedBlocks.parseBlock(0) {
                return Construct.LoopExpressionConstruct(LoopExpression.While(predicate, program))
            }
        }
        return Construct.None
    }

    override var boolOpZones: [DropZone] {
        get {
            let result = getNestedBoolOpZones() + [boolOpZone] + boolOpZone.boolOpZones
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
                let result = [dropZone, nestedDropZone] + nestedBlocks.dropZones
                return result
            } else {
                return []
            }
        }
    }

    private func getNestedBoolOpZones() -> [DropZone] {
        var zones = [DropZone]()
        for block in nestedBlocks.blocks {
            zones.appendContentsOf(block.boolOpZones)
        }
        return zones
    }

    override init(containingBlock: ContainerBlockProtocol) {
        bottomBlock = SKSpriteNode(imageNamed: "endwhile")
        topBlock = SKSpriteNode(imageNamed: "while")
        nestedDropZone = DropZone(size: CGSize(width: 64, height: CodeBlock.dropZoneSize),
                                  dropZoneCategory: BlockCategory.Action,
                                  containingBlock: nestedBlocks)
        boolOpZone = DropZone(size: CGSize(width: CodeBlock.dropZoneSize, height: topBlock.size.height),
                              dropZoneCategory: BlockCategory.BoolOp,
                              containingBlock: containingBlock)
        super.init(containingBlock: containingBlock)
        self.addChild(topBlock)
        self.addChild(nestedDropZone)
        self.addChild(nestedBlocks)
        self.addChild(bottomBlock)
        self.addChild(boolOpZone)
        flushBlocks()
        self.resizeDropZone()
    }

    override func endHover() {
        super.endHover()
        self.unfocus()
        nestedBlocks.unfocus()
    }

    override func flushBlocks() {
        nestedBlocks.flushBlocks()
        if nestedBlocks.count > 0 {
            let nestedBlocksFrame = nestedBlocks.calculateAccumulatedFrame()
            nestedBlocks.position.x = nestingDepth
            bottomBlock.position = CGPoint(x: topBlock.size.width / 2,
                                           y: topBlock.size.height / 2 + CodeBlock.dropZoneSize)
            nestedBlocks.position.y = topBlock.size.height + nestedBlocksFrame.height +
                CodeBlock.dropZoneSize
            topBlock.position = CGPoint(x: topBlock.size.width / 2,
                                        y: 3 * topBlock.size.height / 2 +
                                            2 * CodeBlock.dropZoneSize + nestedBlocksFrame.height)
            boolOpZone.position = CGPoint(x: topBlock.size.width,
                                         y: topBlock.size.height +
                                            2 * CodeBlock.dropZoneSize + nestedBlocksFrame.height)
            nestedDropZone.position = CGPoint(x: nestingDepth, y: topBlock.size.height +
                CodeBlock.dropZoneSize + nestedBlocksFrame.height)
        } else {
            bottomBlock.position = CGPoint(x: topBlock.size.width / 2,
                                           y: topBlock.size.height / 2 + CodeBlock.dropZoneSize)
            topBlock.position = CGPoint(x: topBlock.size.width / 2,
                                        y: 3 * topBlock.size.height / 2 +
                                            2 * CodeBlock.dropZoneSize)
            boolOpZone.position = CGPoint(x: topBlock.size.width, y: topBlock.size.height +
                2 * CodeBlock.dropZoneSize)
            nestedDropZone.position = CGPoint(x: nestingDepth, y: topBlock.size.height + CodeBlock.dropZoneSize)
            nestedBlocks.position = CGPoint(x: nestingDepth, y: topBlock.size.height +
                2 * CodeBlock.dropZoneSize)
        }
    }

    override func activateDropZone() {
        super.activateDropZone()
        nestedDropZone.hidden = false
        nestedBlocks.activateDropZones()
    }

    override func deactivateDropZone() {
        super.deactivateDropZone()
        nestedDropZone.hidden = true
        nestedBlocks.deactivateDropZones()
    }

    override func unfocus() {
        super.unfocus()
        nestedDropZone.displayNormal()
        nestedBlocks.unfocus()
    }

    override func getBlock(location: CGPoint) -> MovableBlockProtocol? {
        let xLocation = location.x - self.position.x
        let yLocation = location.y - self.position.y
        let correctedLocation = CGPoint(x: xLocation, y: yLocation)
        if nestedBlocks.containsPoint(correctedLocation) {
            return nestedBlocks.getBlock(correctedLocation)
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
