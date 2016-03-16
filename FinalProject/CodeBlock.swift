//
//  CodeBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 16/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class CodeBlock: SKNode {
    let dropZone: DropZone
    var blockPosition = 0
    
    override init() {
        dropZone = DropZone(size: CGSizeMake(150, 30))
        super.init()
        self.addChild(dropZone)
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
    
    func endHover() {
        dropZone.displayNormal()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
