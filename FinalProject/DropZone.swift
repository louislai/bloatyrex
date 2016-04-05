//
//  DropZone.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 16/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class DropZone: SKNode {

    let hover: SKShapeNode
    let normal: SKShapeNode
    var containingBlock: ContainerBlockProtocol

    let cornerRadius: CGFloat = 2
    var blockPosition = 0

    init(size: CGSize, containingBlock: ContainerBlockProtocol) {
        normal = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: cornerRadius)
        normal.strokeColor = UIColor.redColor()
        normal.lineWidth = 2
        hover = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: cornerRadius)
        hover.strokeColor = UIColor.redColor()
        hover.lineWidth = 5
        hover.hidden = true
        self.containingBlock = containingBlock
        super.init()
        self.addChild(normal)
        self.addChild(hover)
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
    
    func focus(insertionPosition: InsertionPosition) {
        self.displayHover()
        insertionPosition.position = self.blockPosition + 1
        insertionPosition.container = self.containingBlock
    }
}
