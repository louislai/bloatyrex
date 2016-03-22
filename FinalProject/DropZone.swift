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

    let cornerRadius: CGFloat = 2

    init(size: CGSize) {
        normal = SKShapeNode(rect: CGRectMake(0, 0, size.width, size.height), cornerRadius: cornerRadius)
        normal.strokeColor = UIColor.redColor()
        normal.lineWidth = 2
        hover = SKShapeNode(rect: CGRectMake(0, 0, size.width, size.height), cornerRadius: cornerRadius)
        hover.strokeColor = UIColor.redColor()
        hover.lineWidth = 5
        hover.hidden = true
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
}
