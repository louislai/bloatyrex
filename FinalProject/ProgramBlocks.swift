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
        
        insertionHandler.position = nil
        
        selectClosestDropZone(point, insertionHandler: insertionHandler)
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
    
    func getBlock(location: CGPoint) -> CodeBlock? {
        let x = location.x - self.position.x
        let y = location.y - self.position.y
        for block in blocks {
            if block.containsPoint(CGPointMake(x, y)) {
                return block
            }
        }
        return nil
    }
    
    func selectClosestDropZone(location: CGPoint, insertionHandler: InsertionPosition) {
        var closestDistance = CGFloat.max
        var closestBlock = blocks[0]
        for block in blocks {
            block.unfocus()
            var zone = block.dropZoneCenter
            zone.x += block.position.x
            zone.y += block.position.y
            let distance = (CGFloat)(sqrt(pow((Float)(zone.x - location.x), 2) + pow((Float)(zone.y - location.y), 2)))
            if distance < closestDistance {
                closestDistance = distance
                closestBlock = block
            }
            print("\(block.blockPosition): \(zone) distance: \(distance)")
        }
        closestBlock.focus(insertionHandler)
    }
    
    func reorderBlock(block: CodeBlock, insertionHandler: InsertionPosition) {
        if var position = insertionHandler.position {
            blocks.removeAtIndex(block.blockPosition)
            if block.blockPosition < position {
                position--
            }
            blocks.insert(block, atIndex: position)
            flushBlocks()
        }
    }
    
    private func flushBlocks() {
        var yPos: CGFloat = 0
        let xPos = blocks[0].position.x
        for (i, block) in blocks.enumerate() {
            block.blockPosition = i
            block.position.y = yPos
            block.position.x = xPos
            yPos -= block.calculateAccumulatedFrame().height
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
