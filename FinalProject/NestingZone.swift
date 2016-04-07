//
//  NestingZone.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 4/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class NestingZone: SKNode, ContainerBlockProtocol {
    var blocks = [CodeBlock]()
    var count: Int {
        get {
            return blocks.count
        }
    }
    
    var dropZones: [DropZone] {
        get {
            return blocks.map { $0.dropZone }
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
    
    func removeBlockAtIndex(index: Int) {
        blocks.removeAtIndex(index - 1)
    }
    
    func unfocus() {
        for block in blocks {
            block.unfocus()
        }
    }
    
    func getBlock(location: CGPoint) -> CodeBlock? {
        let x = location.x - self.position.x
        let y = location.y - self.position.y
        let correctedLocation = CGPoint(x: x, y: y)
        for block in blocks {
            if block.containsPoint(correctedLocation) {
                return block.getBlock(correctedLocation)
            }
        }
        return nil
    }
    
    func parseBlock(programCounter: Int) -> Program? {
        guard blocks.count > programCounter else {
            return nil
        }
        
        let block: Statement?
        switch blocks[programCounter].getBlockConstruct() {
        case .ActionConstruct(let action):
            block = Statement.ActionStatement(action)
        case .LoopExpressionConstruct(let loopExpression):
            block = Statement.LoopStatement(loopExpression)
        default:
            block = nil
        }
        
        if let statement = block {
            if blocks.count > programCounter + 1 {
                if let nextBlock = parseBlock(programCounter + 1) {
                    return Program.MultipleStatement(statement, nextBlock)
                } else {
                    return nil
                }
            } else {
                return Program.SingleStatement(statement)
            }
        } else {
            return nil
        }
    }
    
    private func flushBlocks() {
        var yPos: CGFloat = 0
        let xPos: CGFloat = 0
        for (i, block) in blocks.enumerate() {
            block.blockPosition = i + 1
            block.position.x = xPos
            yPos -= block.calculateAccumulatedFrame().height
            block.position.y = yPos
        }
    }
    
    func activateDropZones() {
        for block in blocks {
            block.activateDropZone()
        }
    }
    
    func deactivateDropZones() {
        for block in blocks {
            block.deactivateDropZone()
        }
    }
}
