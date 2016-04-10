//
//  WoodBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 7/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class WoodBlock: ObjectBlock {
    let blockBody: SKSpriteNode
    
    override init(containingBlock: ContainerBlockProtocol, containingZone: DropZone) {
        blockBody = SKSpriteNode(imageNamed: "wooden-block")
        blockBody.size = CGSize(width: 64, height: 64)
        blockBody.position = CGPoint(x: blockBody.size.height / 2, y: blockBody.size.width / 2)
        super.init(containingBlock: containingBlock, containingZone: containingZone)
        addChild(blockBody)
    }
    
    override func getMapUnit() -> MapUnitType {
        return MapUnitType.WoodenBlock
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}