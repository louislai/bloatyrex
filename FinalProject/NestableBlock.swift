//
//  NestableBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 31/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class NestableBlock: CodeBlock {
    let nestingDepth: CGFloat = 20
    let topBlock: SKSpriteNode
    let nestedBlocks = [CodeBlock]()
    let nestedDropZone: DropZone
    let bottomBlock: SKSpriteNode
    
    override var dropZones: [DropZone] {
        get {
            return [dropZone, nestedDropZone]
        }
    }
    
    override init(containingBlock: ContainerBlockProtocol) {
        topBlock = SKSpriteNode(imageNamed: "wall")
        topBlock.position = CGPoint(x: topBlock.size.width / 2,
                                     y: topBlock.size.height / 2 + CodeBlock.dropZoneSize)
        bottomBlock = SKSpriteNode(imageNamed: "wall")
        bottomBlock.position = CGPoint(x: topBlock.size.width / 2,
                                    y: 3 * topBlock.size.height / 2 +
                                        CodeBlock.dropZoneSize + 49)
        nestedDropZone = DropZone(size: CGSize(width: 50, height: 50), containingBlock: containingBlock)
        nestedDropZone.position = CGPoint(x: nestingDepth, y: topBlock.size.height + CodeBlock.dropZoneSize)
        super.init(containingBlock: containingBlock)
        self.addChild(topBlock)
        self.addChild(nestedDropZone)
        self.addChild(bottomBlock)
        self.resizeDropZone()
    }
    
    override func getBlockConstruct() -> Construct {
        return Construct.ActionConstruct(Action.Forward)
    }
    
    override func endHover() {
        super.endHover()
        self.unfocus()
    }
    
    override func unfocus() {
        super.unfocus()
        nestedDropZone.displayNormal()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}