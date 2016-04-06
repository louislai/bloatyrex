//
//  MapUnitNode.swift
//  FinalProject
//
//  Created by louis on 6/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class MapUnitNode: SKSpriteNode {
    let type: MapUnitType

    required init(type: MapUnitType = .EmptySpace) {
        self.type = type
        let texture = TextureManager.retrieveTexture(type.spriteName)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
}

