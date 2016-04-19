//
//  NotSafeBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 19/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class NotSafeBlock: BoolOpBlock {
    let blockBody: SKSpriteNode

    override var objectZones: [DropZone] {
        return []
    }

    override func getBlockPredicate() -> Predicate? {
        return Predicate.NotSafe()
    }

    override init(containingBlock: ContainerBlockProtocol, containingZone: DropZone) {
        blockBody = SKSpriteNode(imageNamed: "not-safe-block")
        let size = GlobalConstants.CodeBlocks.blockSize
        blockBody.size = CGSize(width: size, height: size)
        blockBody.position = CGPoint(x: blockBody.size.height / 2, y: blockBody.size.width / 2)
        super.init(containingBlock: containingBlock, containingZone: containingZone)
        addChild(blockBody)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
