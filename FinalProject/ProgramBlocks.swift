//
//  ProgramBlocks.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 16/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

enum BlockCategory {
    case Action
    case BoolOp
    case Object
}

class ProgramBlocks: SKNode, ContainerBlockProtocol {
    private var blocks = [CodeBlock]()
    private var area = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 0, height: 0))

    override init() {
        super.init()
        blocks.append(MainBlock(containingBlock: self))
        self.addChild(blocks[0])
        flushBlocks()
    }

    func hover(location: CGPoint, category: BlockCategory, insertionHandler: InsertionPosition) {

        insertionHandler.position = nil
        insertionHandler.container = nil

        selectClosestDropZone(location, dropZoneCategory: category, insertionHandler: insertionHandler)
    }

    func selectClosestDropZone(location: CGPoint,
                               dropZoneCategory: BlockCategory,
                               insertionHandler: InsertionPosition) {
        let updatedX = location.x - self.position.x
        let updatedY = location.y - self.position.y
        let location = CGPoint(x: updatedX, y: updatedY)
        var closestDistance = CGFloat.max
        var closestDropZone = blocks[0].actionZones[0]
        for block in blocks {
            block.unfocus()
            let zones: [DropZone]
            switch dropZoneCategory {
            case .Action:
                zones = block.actionZones
            case .BoolOp:
                zones = block.boolOpZones
            case .Object:
                zones = block.objectDropZones
            }
            for zone in zones {
                zone.displayNormal()
                let frame = zone.calculateAccumulatedFrame()
                let center = CGPoint(x: frame.width/2, y: frame.height/2)
                let zonePoint = self.convertPoint(center, fromNode: zone)
                let distance = (CGFloat)(sqrt(pow((Float)(zonePoint.x - location.x), 2)
                    + pow((Float)(zonePoint.y - location.y), 2)))
                if distance < closestDistance {
                    closestDistance = distance
                    closestDropZone = zone
                }
            }
        }
        closestDropZone.focus(insertionHandler)
    }

    func endHover() {
        for block in blocks {
            block.endHover()
            for zone in block.boolOpZones {
                zone.displayNormal()
            }
            for zone in block.objectDropZones {
                zone.displayNormal()
            }
        }
    }

    func insertBlock(block: CodeBlock, insertionPosition: InsertionPosition) {
        if let position = insertionPosition.position {
            blocks.insert(block, atIndex: position)
            self.addChild(block)
            flushBlocks()
        }
    }

    func getBlock(location: CGPoint) -> MovableBlockProtocol? {
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

    func shift(displacement: CGPoint) {
        //blocks[0].position.x += displacement.x
        //blocks[0].position.y += displacement.y
        flushBlocks()
    }

    func getCode() -> Program? {
        if let code = parseBlock(1) {
            return code
        }
        return nil
    }

    func removeBlockAtIndex(index: Int) {
        blocks.removeAtIndex(index)
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
                position -= 1
            }
            blocks.insert(block, atIndex: position)
        }
        flushBlocks()
    }

    private func parseBlock(programCounter: Int) -> Program? {
        guard blocks.count > programCounter else {
            return nil
        }

        let block: Statement?
        switch blocks[programCounter].getBlockConstruct() {
        case .ActionConstruct(let action):
            block = Statement.ActionStatement(action)
        case .LoopExpressionConstruct(let loopExpression):
            block = Statement.LoopStatement(loopExpression)
        case .ConditionalExpressionConstruct(let conditional):
            block = Statement.ConditionalStatement(conditional)
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

    func flushBlocks() {
        var yPos: CGFloat = blocks[0].position.y
        let xPos = blocks[0].position.x
        for (i, block) in blocks.enumerate() {
            if i != 0 {
                block.blockPosition = i
                block.position.x = xPos
                block.flushBlocks()
                yPos -= block.calculateAccumulatedFrame().height
                block.position.y = yPos
            }
        }
        area.removeFromParent()
        let frame = self.calculateAccumulatedFrame()
        let newRect = CGRect(x: -50, y: -frame.height - 50,
                             width: frame.width + 100, height: frame.height + 100)
        area = SKShapeNode(rect: newRect)
        self.addChild(area)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
