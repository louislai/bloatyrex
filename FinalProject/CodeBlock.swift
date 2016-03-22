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

    let dropZone: DropZone
    var blockPosition = 0
    var dropZoneActivated = true
    var dropZoneCenter: CGPoint {
        get {
            if dropZoneActivated {
                let frame = dropZone.calculateAccumulatedFrame()
                return CGPointMake(frame.midX, frame.midY)
            } else {
                return CGPointMake(CGFloat.max, CGFloat.max)
            }
        }
    }

    override init() {
        dropZone = DropZone(size: CGSizeMake(150, CodeBlock.dropZoneSize))
        super.init()
        self.addChild(dropZone)
        dropZone.zPosition = 5
    }

    func hover(location: CGPoint, insertionHandler: InsertionPosition) {
        let x = location.x - self.position.x
        let y = location.y - self.position.y
        if dropZone.containsPoint(CGPointMake(x, y)) {
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
