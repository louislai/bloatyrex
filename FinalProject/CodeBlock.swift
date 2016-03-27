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

    var dropZone: DropZone
    var blockPosition = 0
    var dropZoneActivated = true
    var dropZoneCenter: CGPoint {
        get {
            if dropZoneActivated {
                let frame = dropZone.calculateAccumulatedFrame()
                return CGPoint(x: frame.midX, y: frame.midY)
            } else {
                return CGPoint(x: CGFloat.max, y: CGFloat.max)
            }
        }
    }

    override init() {
        dropZone = DropZone(size: CGSize(width: 150, height: CodeBlock.dropZoneSize))
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
        dropZone = DropZone(size: CGSizeMake(selfFrame.width, CodeBlock.dropZoneSize))
        self.addChild(dropZone)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
