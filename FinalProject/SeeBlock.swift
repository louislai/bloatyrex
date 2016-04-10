//
//  SeeBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 5/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class SeeBlock: BoolOpBlock {
    let blockBody: SKSpriteNode
    let objectDropZone: DropZone
    
    override var objectZones: [DropZone] {
        return [objectDropZone]
    }
    
    override func getBlockPredicate() -> Predicate? {
        if let object = objectDropZone.getObject() {
            return Predicate.CompareObservation(Observation.LookForward, object)
        } else {
            return nil
        }
    }
    
    override func getBlock(location: CGPoint) -> MovableBlockProtocol? {
        let updatedX = location.x - self.position.x
        let updatedY = location.y - self.position.y
        let updatedLocation = CGPoint(x: updatedX, y: updatedY)
        if objectDropZone.containsPoint(updatedLocation) {
            return objectDropZone.getBlock(updatedLocation)
        }
        return self
    }
    
    override init(containingBlock: ContainerBlockProtocol) {
        blockBody = SKSpriteNode(imageNamed: "eyes")
        blockBody.position = CGPoint(x: blockBody.size.height / 2, y: blockBody.size.width / 2)
        objectDropZone = DropZone(size: CGSize(width: CodeBlock.dropZoneSize, height: blockBody.size.height),
                                  dropZoneCategory: BlockCategory.Object,
                                  containingBlock: containingBlock)
        objectDropZone.position = CGPoint(x: blockBody.size.width, y: 0)
        super.init(containingBlock: containingBlock)
        addChild(blockBody)
        addChild(objectDropZone)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
