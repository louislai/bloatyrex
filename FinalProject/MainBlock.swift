//
//  MainBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 16/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class MainBlock: CodeBlock {
    let blockBody: SKShapeNode

    override init() {
        blockBody = SKShapeNode(rect: CGRect(x: 0, y: CodeBlock.dropZoneSize, width: 150, height: 30), cornerRadius: 0)
        blockBody.fillColor = UIColor.blueColor()
        super.init()
        self.addChild(blockBody)
        self.resizeDropZone()
    }

    override func getBlockConstruct() -> Construct {
        return Construct.Main
    }

    override func deactivateDropZone() {
    }

    override func activateDropZone() {
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
