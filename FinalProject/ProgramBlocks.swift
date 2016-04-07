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
    private let trash = TrashZone()

    override init() {
        super.init()
        blocks.append(MainBlock(containingBlock: self))
        trash.position = CGPoint(x: 300, y: -400)
        self.addChild(trash)
        self.addChild(blocks[0])
    }

    func hover(location: CGPoint, category: BlockCategory, insertionHandler: InsertionPosition) {
        let x = location.x - self.position.x
        let y = location.y - self.position.y
        let point = CGPoint(x: x, y: y)

        insertionHandler.position = nil
        insertionHandler.container = nil

        selectClosestDropZone(point, dropZoneCategory: category, insertionHandler: insertionHandler)
    }
    
    func endBoolOpHover() {
        for block in blocks {
            for zone in block.boolOpZones {
                zone.displayNormal()
            }
        }
        trash.unfocus()
    }
    
    func boolOpHover(location: CGPoint, insertionHandler: InsertionPosition) {
        let x = location.x - self.position.x
        let y = location.y - self.position.y
        let point = CGPoint(x: x, y: y)
        
        selectClosestBoolOpZone(point, insertionHandler: insertionHandler)
    }
    
    func selectClosestDropZone(location: CGPoint,
                               dropZoneCategory: BlockCategory,
                               insertionHandler: InsertionPosition) {
        var closestDistance = CGFloat.max
        var closestDropZone = blocks[0].actionZones[0]
        trash.unfocus()
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
                let frame = zone.frame
                let center = CGPoint(x: frame.midX, y: frame.midY)
                let zonePoint = zone.convertPoint(center, toNode: self)
                let distance = (CGFloat)(sqrt(pow((Float)(zonePoint.x - location.x), 2)
                    + pow((Float)(zonePoint.y - location.y), 2)))
                if distance < closestDistance {
                    closestDistance = distance
                    closestDropZone = zone
                }
            }
        }
        let zone = trash.dropZoneCenter
        let trashDistance = (CGFloat)(sqrt(pow((Float)(zone.x - location.x), 2) +
            pow((Float)(zone.y - location.y), 2)))
        insertionHandler.trash = false
        if trashDistance < closestDistance {
            trash.focus(insertionHandler)
            insertionHandler.trash = true
        } else {
            closestDropZone.focus(insertionHandler)
        }
    }
    
    func selectClosestObjectDropZone(location: CGPoint) {
        var closestDistance = CGFloat.max
        var closestBoolOpZone: DropZone?
        trash.unfocus()
        for block in blocks {
            block.unfocus()
            for zone in block.objectDropZones {
                zone.displayNormal()
                let frame = zone.frame
                let center = CGPoint(x: frame.midX, y: frame.midY)
                let zonePoint = zone.convertPoint(center, toNode: self)
                let distance = (CGFloat)(sqrt(pow((Float)(zonePoint.x - location.x), 2)
                    + pow((Float)(zonePoint.y - location.y), 2)))
                if distance < closestDistance {
                    closestDistance = distance
                    closestBoolOpZone = zone
                }
            }
        }
        let zone = trash.dropZoneCenter
        let trashDistance = (CGFloat)(sqrt(pow((Float)(zone.x - location.x), 2) +
            pow((Float)(zone.y - location.y), 2)))
        if trashDistance < closestDistance {
            trash.displayHover()
        } else {
            if let zone = closestBoolOpZone {
                //zone.focus(insertionHandler)
            }
        }
    }
    
    func selectClosestBoolOpZone(location: CGPoint, insertionHandler: InsertionPosition) {
        var closestDistance = CGFloat.max
        var closestBoolOpZone: DropZone?
        trash.unfocus()
        for block in blocks {
            block.unfocus()
            for zone in block.boolOpZones {
                zone.displayNormal()
                let frame = zone.frame
                let center = CGPoint(x: frame.midX, y: frame.midY)
                let zonePoint = zone.convertPoint(center, toNode: self)
                let distance = (CGFloat)(sqrt(pow((Float)(zonePoint.x - location.x), 2)
                    + pow((Float)(zonePoint.y - location.y), 2)))
                if distance < closestDistance {
                    closestDistance = distance
                    closestBoolOpZone = zone
                }
            }
        }
        let zone = trash.dropZoneCenter
        let trashDistance = (CGFloat)(sqrt(pow((Float)(zone.x - location.x), 2) +
            pow((Float)(zone.y - location.y), 2)))
        if trashDistance < closestDistance {
            trash.displayHover()
        } else {
            if let zone = closestBoolOpZone {
                zone.focus(insertionHandler)
            }
        }
    }

    func endHover() {
        for block in blocks {
            block.endHover()
            for zone in block.boolOpZones {
                zone.displayNormal()
            }
        }
        trash.unfocus()
    }

    func insertBlock(block: CodeBlock, insertionPosition: InsertionPosition) {
        if let position = insertionPosition.position {
            blocks.insert(block, atIndex: position)
            self.addChild(block)
            flushBlocks()
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

    func shift(displacement: CGPoint) {
        blocks[0].position.x += displacement.x
        blocks[0].position.y += displacement.y
        flushBlocks()
    }

    func getCode() -> Program? {
        return parseBlock(1)
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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
