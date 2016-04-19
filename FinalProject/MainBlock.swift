//
//  MainBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 16/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

/// The MainBlock is the leading block of any code blocks program
class MainBlock: CodeBlock {
    let blockBody: SKShapeNode

    override init(containingBlock: ContainerBlockProtocol) {
        blockBody = SKShapeNode(rect: CGRect(x: 0, y: CodeBlock.dropZoneSize, width: 150, height: 30), cornerRadius: 0)
        blockBody.fillColor = UIColor.blueColor()
        super.init(containingBlock: containingBlock)
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
