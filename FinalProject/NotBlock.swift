//
//  NotBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 11/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class NotBlock: BoolOpBlock {
    let blockBody: SKSpriteNode
    let boolOpZone: DropZone

    override var boolOpZones: [DropZone] {
        return [boolOpZone] + boolOpZone.boolOpZones
    }

    override var objectZones: [DropZone] {
        return boolOpZone.objectZones
    }

    override func getBlockPredicate() -> Predicate? {
        if let predicate = boolOpZone.getBlockPredicate() {
            return Predicate.Negation(predicate)
        } else {
            return nil
        }
    }

    override func getBlock(location: CGPoint) -> MovableBlockProtocol? {
        let updatedX = location.x - self.position.x
        let updatedY = location.y - self.position.y
        let updatedLocation = CGPoint(x: updatedX, y: updatedY)
        if boolOpZone.containsPoint(updatedLocation) {
            return boolOpZone.getBlock(updatedLocation)
        }
        return self
    }

    override init(containingBlock: ContainerBlockProtocol, containingZone: DropZone) {
        blockBody = SKSpriteNode(imageNamed: GlobalConstants.ImageNames.not_block)
        let size = GlobalConstants.CodeBlocks.blockSize
        blockBody.size = CGSize(width: size, height: size)
        blockBody.position = CGPoint(x: blockBody.size.height / 2, y: blockBody.size.width / 2)
        boolOpZone = DropZone(size: CGSize(width: CodeBlock.dropZoneSize, height: blockBody.size.height),
                                  dropZoneCategory: BlockCategory.BoolOp,
                                  containingBlock: containingBlock)
        boolOpZone.position = CGPoint(x: blockBody.size.width, y: 0)
        super.init(containingBlock: containingBlock, containingZone: containingZone)
        addChild(blockBody)
        addChild(boolOpZone)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
