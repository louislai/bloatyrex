//
//  GameScene.swift
//  FinalProject
//
//  Created by louis on 12/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class MapNode: SKNode {
    var map: Map
    let blocksLayer = SKNode()
    let unitsLayer = SKNode()
    var activeAgentNodes = [AgentNode]()
    var originalMovesLeft = 30
    private var numberOfRows: Int {
        return map.numberOfRows
    }
    private var numberOfColumns: Int {
        return map.numberOfColumns
    }
    var blockSize: CGSize {
        return CGSize(
            width: GlobalConstants.Dimension.blockWidth,
            height: GlobalConstants.Dimension.blockHeight
        )
    }

    init(size: CGSize, map: Map) {
        self.map = map
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not used")
    }

    func setup() {
        let layerPosition = CGPoint(
            x: -GlobalConstants.Dimension.blockWidth * CGFloat(numberOfColumns) / 2,
            y: -GlobalConstants.Dimension.blockHeight * CGFloat(numberOfRows) / 2
        )

        // The blocksLayer represent the shape of the map.
        // Each block is a square
        blocksLayer.position = layerPosition
        addChild(blocksLayer)

        // This layer holds the MapUnit sprites. The positions of these sprites
        // are relative to the unitsLayer's bottom-left corner.
        unitsLayer.position = layerPosition
        addChild(unitsLayer)
        addBlocks()
        setupMapUnits()
    }

    func addBlocks() {
        for row in 0..<numberOfRows {
            for column in 0..<numberOfColumns {
                let blockNode = MapUnitType.EmptySpace.nodeClass.init()
                blockNode.size = blockSize
                blockNode.position = pointFor(row, column: column)
                blocksLayer.addChild(blockNode)
            }
        }
    }


    func setupMapUnits() {
        for row in 0..<numberOfRows {
            for column in 0..<numberOfColumns {
                if let unit = map.retrieveMapUnitAt(row, column: column)
                    where unit.type != .EmptySpace {
                    let sprite = unit
                    if unit.type == .Agent {
                        sprite.texture = TextureManager.agentUpTexture
                    }

                    sprite.position = pointFor(row, column: column)
                    sprite.size = blockSize
                    sprite.zPosition = GlobalConstants.zPosition.back
                    if let sprite = sprite as? AgentNode {
                        sprite.zPosition = GlobalConstants.zPosition.front
                        sprite.mapNode = self
                        sprite.row = row
                        sprite.column = column
                        activeAgentNodes.append(sprite)
                    }
                    unitsLayer.addChild(sprite)
                }
            }
        }
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
