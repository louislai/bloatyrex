//
//  BlockButton.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 16/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

enum BlockType {
    case Main
    case Forward
    case TurnLeft
    case TurnRight
}

class BlockButton: SKNode {
    let button: SKSpriteNode
    let block: SKSpriteNode
    let blockType: BlockType
    var selected = false
    
    init(imageNamed: String, blockType: BlockType) {
        button = SKSpriteNode(imageNamed: imageNamed)
        block = SKSpriteNode(imageNamed: imageNamed)
        block.hidden = true
        self.blockType = blockType
        super.init()
        self.addChild(button)
        self.addChild(block)
    }
    
    func pickBlock(selected: Bool) {
        self.selected = selected
        if selected {
            block.hidden = false
        } else {
            block.hidden = true
            block.position = CGPointMake(0, 0)
        }
    }
    
    func moveBlock(displacement: CGPoint) {
        block.position.x += displacement.x
        block.position.y += displacement.y
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
