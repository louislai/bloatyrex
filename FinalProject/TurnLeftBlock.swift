//
//  TurnLeftBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 16/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class TurnLeftBlock: CodeBlock {
    let blockBody: SKSpriteNode

    override init() {
        blockBody = SKSpriteNode(imageNamed: "turn-left-block")
        blockBody.position = CGPoint(x: blockBody.size.width / 2,
            y: blockBody.size.height / 2 + CodeBlock.dropZoneSize)
        super.init()
        self.addChild(blockBody)
        self.resizeDropZone()
    }

    override func getBlockConstruct() -> Construct {
        return Construct.ActionConstruct(Action.RotateLeft)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
