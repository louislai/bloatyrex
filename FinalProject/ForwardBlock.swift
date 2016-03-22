//
//  ForwardBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 16/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class ForwardBlock: CodeBlock {
    let blockBody: SKShapeNode

    override init() {
        blockBody = SKShapeNode(rect: CGRectMake(0, CodeBlock.dropZoneSize, 150, 30), cornerRadius: 0)
        blockBody.fillColor = UIColor.greenColor()
        super.init()
        self.addChild(blockBody)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
