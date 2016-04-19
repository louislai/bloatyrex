//
//  GameScene.swift
//  FinalProject
//
//  Created by louis on 12/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

struct StaticMapSceneConstants {
    struct NodeNames {
        static let movesLeftLabel = "movesLeft"
    }
}

class StaticMapScene: PannableScene {
    var mapNode: MapNode
    let hudLayer = SKNode()

    init(size: CGSize, zoomLevel: CGFloat, map: Map) {
        self.mapNode = MapNode(size: size, map: map)
        super.init(size: size, zoomLevel: zoomLevel)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not used")
    }

    func setup() {
        addNodeToContent(mapNode)
        mapNode.setup()
        addNodeToOverlay(hudLayer)
        setupHud()
    }

    func setupHud() {
        // 1
        let movesLeftLabel = SKLabelNode(text: "MOVES LEFT: ")
        movesLeftLabel.name = StaticMapSceneConstants.NodeNames.movesLeftLabel
        movesLeftLabel.fontName = GlobalConstants.Font.defaultNameBold
        movesLeftLabel.fontColor = GlobalConstants.Font.defaultGreen

        let layerPosition = CGPoint(
            x: 0,
            y: 300.0
        )
        movesLeftLabel.text = String(format: "MOVES LEFT: %d", mapNode.originalMovesLeft)

        // 3
        movesLeftLabel.position = layerPosition
        hudLayer.addChild(movesLeftLabel)
    }

    // Convert a row, column pair into a CGPoint relative
    // to unitsLayer
    func pointFor(row: Int, column: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*GlobalConstants.Dimension.blockWidth,
            y: CGFloat(row)*GlobalConstants.Dimension.blockHeight
        )
    }
}
