//
//  TrashZone.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 16/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class TrashZone: DropZone {
    
    var dropZoneCenter: CGPoint {
        get {
            let frame = self.calculateAccumulatedFrame()
            return CGPointMake(frame.midX, frame.midY)
        }
    }
    
    init() {
        let trash = SKSpriteNode(imageNamed: "trash-container")
        trash.size.width = 100
        trash.size.height = 100
        let size = trash.calculateAccumulatedFrame()
        super.init(size: CGSize(width: size.width, height: size.height))
        self.addChild(trash)
        trash.position.x = size.width/2
        trash.position.y = size.height/2
    }
    
    func focus(insertionHandler: InsertionPosition) {
        insertionHandler.trash = true
        self.displayHover()
    }
    
    func unfocus() {
        self.displayNormal()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
