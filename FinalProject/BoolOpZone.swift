//
//  BoolOpZone.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 5/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class BoolOpZone: SKNode {
    
    let hover: SKShapeNode
    let normal: SKShapeNode
    
    let cornerRadius: CGFloat = 2
    var boolOpBlock: BoolOpBlock?
    var blockPosition = 0
    
    init(size: CGSize) {
        normal = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: cornerRadius)
        normal.strokeColor = UIColor.purpleColor()
        normal.lineWidth = 2
        hover = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: cornerRadius)
        hover.strokeColor = UIColor.purpleColor()
        hover.lineWidth = 5
        hover.hidden = true
        super.init()
        self.addChild(normal)
        self.addChild(hover)
    }
    
    func insertBlock(block: BoolOpBlock) {
        boolOpBlock = block
        block.position = CGPoint(x: 32, y: 32)
        normal.hidden = true
        hover.hidden = true
        self.addChild(block)
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
    
    func focus(insertionPosition: BoolOpInsertionPosition) {
        self.displayHover()
        insertionPosition.zone = self
    }
}