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
    case While
    case Eyes
    case Toilet
    case Wall
    case Hole
    case Wood
    case If
    case Not
    case Safe
    case Wait
    case Jump
    case PressBlue
    case PressRed
}

class BlockButton: SKNode {
    let button: SKSpriteNode
    let block: SKSpriteNode
    let blockType: BlockType
    let blockCategory: BlockCategory
    var selected = false

    init(imageNamed: String, blockType: BlockType, blockCategory: BlockCategory) {
        button = SKSpriteNode(imageNamed: imageNamed)
        block = SKSpriteNode(imageNamed: imageNamed)
        button.size = CGSize(width: 64, height: 64)
        block.size = CGSize(width: 64, height: 64)
        block.hidden = true
        self.blockType = blockType
        self.blockCategory = blockCategory
        super.init()
        self.addChild(button)
        self.addChild(block)
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
