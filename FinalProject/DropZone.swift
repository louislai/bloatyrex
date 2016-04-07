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
    var containingBlock: ContainerBlockProtocol
    var boolOpBlock: BoolOpBlock?
    
    var objectZones: [DropZone] {
        get {
            if let block = boolOpBlock {
                return block.objectZones
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
        hover.hidden = false
        normal.hidden = true
    }

    func displayNormal() {
        hover.hidden = true
        normal.hidden = false
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
        boolOpBlock = block
        normal.hidden = true
        hover.hidden = true
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
            break
        }
    }
}
