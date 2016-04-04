//
//  NestingZone.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 4/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class NestingZone: SKNode, ContainerBlockProtocol {
    private var blocks = [CodeBlock]()
    var count: Int {
        get {
            return blocks.count
        }
    }
    
    func insertBlock(block: CodeBlock, insertionPosition: InsertionPosition) {
        if let position = insertionPosition.position {
            blocks.insert(block, atIndex: position - 1)
            self.addChild(block)
            flushBlocks()
            print()
        }
    }
    
    private func flushBlocks() {
        var yPos: CGFloat = 0
        let xPos: CGFloat = 0
        for (i, block) in blocks.enumerate() {
            block.blockPosition = i
            block.position.x = xPos
            yPos -= block.calculateAccumulatedFrame().height
            block.position.y = yPos
        }
    }
}
