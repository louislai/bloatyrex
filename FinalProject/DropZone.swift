//
//  DropZone.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 16/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class DropZone: SKNode {

    private var hover: SKShapeNode
    private var normal: SKShapeNode
    let category: BlockCategory
    var activated = true
    var containingBlock: ContainerBlockProtocol
    var boolOpBlock: BoolOpBlock?
    var objectBlock: ObjectBlock?

    var objectZones: [DropZone] {
        get {
            if let block = boolOpBlock {
                return block.objectZones
            } else {
                return []
            }
        }
    }

    var boolOpZones: [DropZone] {
        get {
            if let block = boolOpBlock {
                return block.boolOpZones
            } else {
                return []
            }
        }
    }

    let cornerRadius: CGFloat = 2
    var blockPosition = 0

    init(size: CGSize, dropZoneCategory: BlockCategory, containingBlock: ContainerBlockProtocol) {
        self.category = dropZoneCategory
        self.containingBlock = containingBlock

        normal = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: cornerRadius)
        hover = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: cornerRadius)
        normal.lineWidth = 2
        hover.lineWidth = 5
        hover.hidden = true

        super.init()
        colorZone()

        self.addChild(normal)
        self.addChild(hover)
    }

    private func colorZone() {
        switch category {
        case .Action:
            colorActionZone()
        case .BoolOp:
            colorBoolOpZone()
        case .Object:
            colorObjectZone()
        }
    }

    private func colorActionZone() {
        normal.strokeColor = UIColor.redColor()
        hover.strokeColor = UIColor.redColor()
    }

    private func colorBoolOpZone() {
        normal.strokeColor = UIColor.purpleColor()
        hover.strokeColor = UIColor.purpleColor()
    }

    private func colorObjectZone() {
        normal.strokeColor = UIColor.greenColor()
        hover.strokeColor = UIColor.greenColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func displayHover() {
        if activated {
            hover.hidden = false
            normal.hidden = true
        }
    }

    func displayNormal() {
        if activated {
            hover.hidden = true
            normal.hidden = false
        }
    }

    func resize(size: CGSize) {
        normal.removeFromParent()
        hover.removeFromParent()
        normal = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: cornerRadius)
        hover = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: cornerRadius)
        normal.lineWidth = 2
        hover.lineWidth = 5
        hover.hidden = true
        colorZone()
        self.addChild(normal)
        self.addChild(hover)
    }

    func insertBlock(block: BoolOpBlock) {
        if let previousBlock = boolOpBlock {
            previousBlock.removeFromParent()
        }
        boolOpBlock = block
        normal.hidden = true
        hover.hidden = true
        activated = false
        block.position = CGPoint(x: 0, y: 0)
        self.addChild(block)
    }

    func insertObjectBlock(block: ObjectBlock) {
        if let previousBlock = objectBlock {
            previousBlock.removeFromParent()
        }
        objectBlock = block
        normal.hidden = true
        hover.hidden = true
        activated = false
        block.position = CGPoint(x: 0, y: 0)
        self.addChild(block)
    }

    func focus(insertionPosition: InsertionPosition) {
        self.displayHover()
        insertionPosition.category = self.category
        switch category {
        case .Action:
            insertionPosition.position = self.blockPosition + 1
            insertionPosition.container = self.containingBlock
        case .BoolOp:
            insertionPosition.zone = self
            insertionPosition.container = self.containingBlock
        case .Object:
            insertionPosition.zone = self
            insertionPosition.container = self.containingBlock
        }
    }

    func removeBoolOp() {
        normal.hidden = false
        activated = true
        boolOpBlock = nil
    }

    func removeObject() {
        normal.hidden = false
        activated = true
        objectBlock = nil
    }

    func getBlockPredicate() -> Predicate? {
        switch category {
        case .Action:
            return nil
        case .BoolOp:
            return boolOpBlock?.getBlockPredicate()
        case .Object:
            return nil
        }
    }

    func getObject() -> MapUnitType? {
        switch category {
        case .Action:
            return nil
        case .BoolOp:
            return nil
        case .Object:
            return objectBlock?.getMapUnit()
        }
    }

    func getBlock(location: CGPoint) -> MovableBlockProtocol? {
        let correctedX = location.x - self.position.x
        let correctedY = location.y - self.position.y
        let updatedLocation = CGPoint(x: correctedX, y: correctedY)
        switch category {
        case .Action:
            return nil
        case .BoolOp:
            if let block = boolOpBlock {
                if block.containsPoint(updatedLocation) {
                    self.activated = true
                    return block.getBlock(updatedLocation)
                }
            }
        case .Object:
            if let block = objectBlock {
                if block.containsPoint(updatedLocation) {
                    self.activated = true
                    return objectBlock!
                }
            }
        }
        return nil
    }
}
