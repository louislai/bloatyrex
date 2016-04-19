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
    var exploded = false

    required init(type: MapUnitType = .EmptySpace) {
        self.type = type
        let texture = type.texture
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    override func copyWithZone(zone: NSZone) -> AnyObject {
        return type.nodeClass.init(type: type)
    }

    func runExplodingAnimation() {
        texture = nil
        let deathEmitter = SKEmitterNode(fileNamed: "Spark.sks")
        addChild(deathEmitter!)
        exploded = true
    }
}
