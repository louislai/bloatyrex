//
//  BlockButton.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 16/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class BlockButton: SKNode {
    let button: SKSpriteNode
    let block: SKSpriteNode
    private var actionFunc: ((ContainerBlockProtocol) -> CodeBlock)?
    private var boolOpFunc: ((ContainerBlockProtocol, DropZone) -> BoolOpBlock)?
    private var objectFunc: ((ContainerBlockProtocol, DropZone) -> ObjectBlock)?
    let blockCategory: BlockCategory
    var selected = false

    init(imageNamed: String, blockCategory: BlockCategory, action: (ContainerBlockProtocol) -> CodeBlock) {
        button = SKSpriteNode(imageNamed: imageNamed)
        block = SKSpriteNode(imageNamed: imageNamed)
        let size = GlobalConstants.CodeBlocks.blockSize
        button.size = CGSize(width: size, height: size)
        block.size = CGSize(width: size, height: size)
        block.hidden = true
        self.actionFunc = action
        self.blockCategory = blockCategory
        super.init()
        self.addChild(button)
        self.addChild(block)
    }
    
    init(imageNamed: String, blockCategory: BlockCategory, object: (ContainerBlockProtocol, DropZone) -> ObjectBlock) {
        button = SKSpriteNode(imageNamed: imageNamed)
        block = SKSpriteNode(imageNamed: imageNamed)
        let size = GlobalConstants.CodeBlocks.blockSize
        button.size = CGSize(width: size, height: size)
        block.size = CGSize(width: size, height: size)
        block.hidden = true
        self.objectFunc = object
        self.blockCategory = blockCategory
        super.init()
        self.addChild(button)
        self.addChild(block)
    }
    
    init(imageNamed: String, blockCategory: BlockCategory, boolOp: (ContainerBlockProtocol, DropZone) -> BoolOpBlock) {
        button = SKSpriteNode(imageNamed: imageNamed)
        block = SKSpriteNode(imageNamed: imageNamed)
        let size = GlobalConstants.CodeBlocks.blockSize
        button.size = CGSize(width: size, height: size)
        block.size = CGSize(width: size, height: size)
        block.hidden = true
        self.boolOpFunc = boolOp
        self.blockCategory = blockCategory
        super.init()
        self.addChild(button)
        self.addChild(block)
    }
    
    func getAction(container: ContainerBlockProtocol) -> CodeBlock? {
        if let fun = actionFunc {
            return fun(container)
        }
        return nil
    }
    
    func getObject(container: ContainerBlockProtocol, zone: DropZone) -> ObjectBlock? {
        if let fun = objectFunc {
            return fun(container, zone)
        }
        return nil
    }
    
    func getBoolOp(container: ContainerBlockProtocol, zone: DropZone) -> BoolOpBlock? {
        if let fun = boolOpFunc {
            return fun(container, zone)
        }
        return nil
    }

    func pickBlock(selected: Bool, scale: CGFloat) {
        self.selected = selected
        if selected {
            block.hidden = false
            block.setScale(scale)
        } else {
            block.hidden = true
            block.position = CGPoint(x: 0, y: 0)
        }
    }

    func dropBlock() {
        block.hidden = true
        block.position = CGPoint(x: 0, y: 0)
    }

    func moveBlock(displacement: CGPoint) {
        block.position.x += displacement.x
        block.position.y += displacement.y
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
