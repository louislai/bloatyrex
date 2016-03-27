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
    private let trash = TrashZone()

    override init() {
        super.init()
        blocks.append(MainBlock())
        trash.position = CGPoint(x: 300, y: -400)
        self.addChild(trash)
        self.addChild(blocks[0])
    }

    func hover(location: CGPoint, insertionHandler: InsertionPosition) {
        let x = location.x - self.position.x
        let y = location.y - self.position.y
        let point = CGPoint(x: x, y: y)

        insertionHandler.position = nil

        selectClosestDropZone(point, insertionHandler: insertionHandler)
    }

    func endHover() {
        for block in blocks {
            block.endHover()
        }
        trash.unfocus()
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
            if block.containsPoint(CGPoint(x: x, y: y)) {
                return block
            }
        }
        return nil
    }

    func shift(displacement: CGPoint) {
        blocks[0].position.x += displacement.x
        blocks[0].position.y += displacement.y
        flushBlocks()
    }

    func selectClosestDropZone(location: CGPoint, insertionHandler: InsertionPosition) {
        var closestDistance = CGFloat.max
        var closestBlock = blocks[0]
        trash.unfocus()
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
        }
        let zone = trash.dropZoneCenter
        let trashDistance = (CGFloat)(sqrt(pow((Float)(zone.x - location.x), 2) + pow((Float)(zone.y - location.y), 2)))
        insertionHandler.trash = false
        if trashDistance < closestDistance {
            trash.focus(insertionHandler)
        } else {
            closestBlock.focus(insertionHandler)
        }
    }

    func reorderBlock(block: CodeBlock, insertionHandler: InsertionPosition) {
        if insertionHandler.trash {
            if let _ = block as? MainBlock {
                return
            } else {
                blocks.removeAtIndex(block.blockPosition)
                block.removeFromParent()
            }
        }
        if var position = insertionHandler.position {
            blocks.removeAtIndex(block.blockPosition)
            if block.blockPosition < position {
                position--
            }
            blocks.insert(block, atIndex: position)
        }
        flushBlocks()
    }
    
    func getCode() -> Program? {
        return parseBlock(1)
    }
    
    private func parseBlock(programCounter: Int) -> Program? {
        guard blocks.count > programCounter else {
            return nil
        }
        
        let block: Statement?
        switch blocks[programCounter].getBlockConstruct() {
        case .ActionConstruct(let action):
            block = Statement.ActionStatement(action)
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
        var yPos: CGFloat = blocks[0].position.y
        let xPos = blocks[0].position.x
        for (i, block) in blocks.enumerate() {
            if i != 0 {
                block.blockPosition = i
                block.position.x = xPos
                yPos -= block.calculateAccumulatedFrame().height
                block.position.y = yPos
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
