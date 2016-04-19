//
//  JumpBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 19/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//


import SpriteKit

class JumpBlock: CodeBlock, HighlightableBlockProtocol {
    let blockBody: SKSpriteNode
    var highlightLayer: SKShapeNode?

    func highlight() {
        unhighlight()
        let frame = blockBody.calculateAccumulatedFrame()
        let newLayer = SKShapeNode(rect: CGRect(x: 0, y: CodeBlock.dropZoneSize, width: frame.width, height: frame.height),
                                   cornerRadius: 0)
        newLayer.fillColor = UIColor.yellowColor()
        newLayer.alpha = 0.3
        newLayer.zPosition = 3
        self.addChild(newLayer)
        highlightLayer = newLayer
    }

    func unhighlight() {
        if let layer = highlightLayer {
            layer.removeFromParent()
        }
    }

    override init(containingBlock: ContainerBlockProtocol) {
        blockBody = SKSpriteNode(imageNamed: "jump-block")
        blockBody.position = CGPoint(x: blockBody.size.width / 2,
                                     y: blockBody.size.height / 2 + CodeBlock.dropZoneSize)
        super.init(containingBlock: containingBlock)
        self.addChild(blockBody)
        self.resizeDropZone()
    }

    override func getBlockConstruct() -> Construct {
        return Construct.ActionConstruct(Action.Jump(self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
