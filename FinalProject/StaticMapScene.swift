//
//  GameScene.swift
//  FinalProject
//
//  Created by louis on 12/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// A static map scene containing the game environment
///
/// Public Properties:
/// - mapNode: the map node for game
/// - hudLayer: the hud layer
/// - levelName: the name of the map

import SpriteKit

struct StaticMapSceneConstants {
    struct NodeNames {
        static let movesLeftLabel = "movesLeft"
        static let levelNameLabel = "levelName"
    }
}

class StaticMapScene: PannableScene {
    var mapNode: MapNode
    let hudLayer = SKNode()
    let levelName: String

    init(size: CGSize, zoomLevel: CGFloat, map: Map, levelName: String) {
        self.mapNode = MapNode(size: size, map: map)
        self.levelName = levelName
        super.init(size: size, initialZoomLevel: zoomLevel)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not used")
    }

    var hudFontSize: CGFloat {
        return 25.0
    }
    var movesLeftLabelPosition: CGPoint {
        return CGPoint(
            x: 0,
            y: 250.0
        )
    }
    var levelNameLabelPosition: CGPoint {
        return CGPoint(
            x: 0,
            y: 300.0
        )
    }

    /// Setup the environment for the game
    func setup() {
        addNodeToContent(mapNode)
        mapNode.setup()
        addNodeToOverlay(hudLayer)
        setupHud()
    }

    /// Convert a row, column pair into a CGPoint coordinate
    func pointFor(row: Int, column: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*GlobalConstants.Dimension.blockWidth,
            y: CGFloat(row)*GlobalConstants.Dimension.blockHeight
        )
    }

    private func setupHud() {
        // 1
        let movesLeftLabel = SKLabelNode(text: "MOVES LEFT: ")
        movesLeftLabel.name = StaticMapSceneConstants.NodeNames.movesLeftLabel
        movesLeftLabel.fontName = GlobalConstants.Font.defaultNameBold
        movesLeftLabel.fontColor = GlobalConstants.Font.defaultGreen
        movesLeftLabel.fontSize = hudFontSize
        movesLeftLabel.text = String(format: "MOVES LEFT: %d", mapNode.originalMovesLeft)
        movesLeftLabel.position = movesLeftLabelPosition

        let levelNameLabel = SKLabelNode(text: levelName.uppercaseString)
        levelNameLabel.fontName = GlobalConstants.Font.defaultNameBold
        levelNameLabel.name = StaticMapSceneConstants.NodeNames.levelNameLabel
        levelNameLabel.fontColor = GlobalConstants.Font.defaultGreen
        levelNameLabel.position = levelNameLabelPosition
        levelNameLabel.fontSize = hudFontSize

        hudLayer.addChild(movesLeftLabel)
        hudLayer.addChild(levelNameLabel)
    }
}
