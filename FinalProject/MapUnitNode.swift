//
//  MapUnitNode.swift
//  FinalProject
//
//  Created by louis on 6/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// The parent class for unit node node class
/// 
/// Public Properties:
/// - type: the unit type, enumerated in MapUnitType
/// - exploded: whether this unit type has exploded
/// - row: the row position of the unit in the map grid
/// - column: the column position of the unit the map grid
/// - mapNode: the attached mapNode node

import SpriteKit

class MapUnitNode: SKSpriteNode {
    var type: MapUnitType
    var exploded = false
    var row: Int!
    var column: Int!
    weak var mapNode: MapNode!

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
        let deathEmitter = SKEmitterNode(fileNamed: GlobalConstants.explosionEmitterName)
        addChild(deathEmitter!)
        exploded = true
        mapNode.map.clearMapUnitAt(row, column: column)
    }
}
