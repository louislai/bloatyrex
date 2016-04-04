//
//  ForwardBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 16/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class ForwardBlock: CodeBlock {
    let blockBody: SKSpriteNode

    override init(containingBlock: ContainerBlockProtocol) {
        blockBody = SKSpriteNode(imageNamed: "up-block")
        blockBody.position = CGPoint(x: blockBody.size.width / 2,
            y: blockBody.size.height / 2 + CodeBlock.dropZoneSize)
        super.init(containingBlock: containingBlock)
        self.addChild(blockBody)
        self.resizeDropZone()
    }

    override func getBlockConstruct() -> Construct {
        return Construct.ActionConstruct(Action.Forward)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
