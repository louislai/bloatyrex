//
//  SeeBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 5/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class SeeBlock: BoolOpBlock {
    let blockBody: SKSpriteNode
    let objectDropZone: ObjectDropZone
    
    override var objectDropZones: [ObjectDropZone] {
        return [objectDropZone]
    }
    
    override init() {
        blockBody = SKSpriteNode(imageNamed: "eyes")
        blockBody.position = CGPoint(x: blockBody.size.height / 2, y: blockBody.size.width / 2)
        objectDropZone = ObjectDropZone(size: CGSize(width: CodeBlock.dropZoneSize, height: blockBody.size.height))
        objectDropZone.position = CGPoint(x: blockBody.size.width, y: 0)
        super.init()
        addChild(blockBody)
        addChild(objectDropZone)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
