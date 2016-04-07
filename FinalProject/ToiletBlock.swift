//
//  ToiletBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 6/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
import SpriteKit

class ToiletBlock: ObjectBlock {
    let blockBody: SKSpriteNode
    
    init(containingBlock: ContainerBlockProtocol) {
        blockBody = SKSpriteNode(imageNamed: "toilet")
        blockBody.size = CGSize(width: 64, height: 64)
        blockBody.position = CGPoint(x: blockBody.size.height / 2, y: blockBody.size.width / 2)
        super.init()
        addChild(blockBody)
    }
    
    override func getMapUnit() -> MapUnitType {
        return MapUnitType.Goal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}