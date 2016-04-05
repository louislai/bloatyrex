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
    
    override init() {
        blockBody = SKSpriteNode(imageNamed: "eyes")
        super.init()
        addChild(blockBody)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
