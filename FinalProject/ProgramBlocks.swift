//
//  ProgramBlocks.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 16/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class ProgramBlocks: SKNode {
    private var blocks = [CodeBlock]()
    
    override init() {
        super.init()
        blocks.append(MainBlock())
        self.addChild(blocks[0])
    }
    
    func hover(location: CGPoint, insertionHandler: InsertionPosition) {
        let x = location.x - self.position.x
        let y = location.y - self.position.y
        let point = CGPointMake(x, y)
        
        for block in blocks {
            if block.containsPoint(point) {
                block.hover(point, insertionHandler: insertionHandler)
            } else {
                block.endHover()
            }
        }
    }
    
    func endHover() {
        for block in blocks {
            block.endHover()
        }
    }
    
    func insertBlock(block: CodeBlock, insertionHandler: InsertionPosition) {
        if let position = insertionHandler.position {
            blocks.insert(block, atIndex: position)
            self.addChild(block)
            flushBlocks()
        }
    }
    
    private func flushBlocks() {
        var pos: CGFloat = 0
        for (i, block) in blocks.enumerate() {
            block.blockPosition = i
            block.position.y = pos
            pos -= block.calculateAccumulatedFrame().height
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
