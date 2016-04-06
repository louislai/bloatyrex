//
//  CodeBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 16/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class CodeBlock: SKNode {
    static let dropZoneSize: CGFloat = 10

    private var containingBlockValue: ContainerBlockProtocol
    var containingBlock: ContainerBlockProtocol {
        get {
            return containingBlockValue
        }
        
        set(newBlock) {
            containingBlockValue = newBlock
            dropZone.containingBlock = newBlock
        }
    }
    
    var boolOpZones: [DropZone] {
        get {
            return []
        }
    }
    
    var objectDropZones: [DropZone] {
        get {
            return []
        }
    }
    
    var dropZone: DropZone
    private var blockPositionValue = 0
    var blockPosition: Int {
        get {
            return blockPositionValue
        }
        
        set(newPosition) {
            dropZone.blockPosition = newPosition
            blockPositionValue = newPosition
        }
    }
    var dropZoneActivated = true
    var actionZones: [DropZone] {
        get {
            return [dropZone]
        }
    }

    init(containingBlock: ContainerBlockProtocol) {
        dropZone = DropZone(size: CGSize(width: 150, height: CodeBlock.dropZoneSize),
                            dropZoneCategory: BlockCategory.Action,
                            containingBlock: containingBlock)
        self.containingBlockValue = containingBlock
        super.init()
        resizeDropZone()
        dropZone.zPosition = 5
    }

    func getBlockConstruct() -> Construct {
        return Construct.None
    }

    func hover(location: CGPoint, insertionHandler: InsertionPosition) {
        let x = location.x - self.position.x
        let y = location.y - self.position.y
        if dropZone.containsPoint(CGPoint(x: x, y: y)) {
            dropZone.displayHover()
            insertionHandler.position = blockPosition + 1
        } else {
            dropZone.displayNormal()
            insertionHandler.position = nil
        }
    }

    func focus(insertionHandler: InsertionPosition) {
        dropZone.displayHover()
        insertionHandler.position = blockPosition + 1
    }

    func unfocus() {
        dropZone.displayNormal()
    }

    func endHover() {
        dropZone.displayNormal()
    }

    func deactivateDropZone() {
        dropZoneActivated = false
        dropZone.hidden = true
    }

    func activateDropZone() {
        dropZoneActivated = true
        dropZone.hidden = false
    }

    func resizeDropZone() {
        dropZone.removeFromParent()
        let selfFrame = self.calculateAccumulatedFrame()
        dropZone.resize(CGSize(width: selfFrame.width, height: CodeBlock.dropZoneSize))
        dropZone.blockPosition = self.blockPosition
        self.addChild(dropZone)
    }
    
    func flushBlocks() {
        return
    }
    
    func getBlock(location: CGPoint) -> CodeBlock? {
        return self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
