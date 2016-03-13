//
//  GameScene.swift
//  FinalProject
//
//  Created by louis on 12/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class PlayingMapScene: SKScene {
    var map: Map!
    var running = false
    let blocksLayer = SKNode()
    let unitsLayer = SKNode()
    var activeAgentNodes = [AgentNode]()
    private var numberOfRows: Int {
        return map.numberOfRows
    }
    private var numberOfColumns: Int {
        return map.numberOfColumns
    }
    let blockWidth = CGFloat(100.0)
    let blockHeight = CGFloat(100.0)
    var blockSize: CGSize {
        return CGSize(
            width: blockWidth,
            height: blockHeight
            )
    }

    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not used")
    }

    func setup() {
        let layerPosition = CGPoint(
            x: -blockWidth * CGFloat(numberOfColumns) / 2,
            y: -blockHeight * CGFloat(numberOfRows) / 2
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
                let blockNode = SKSpriteNode(texture: TextureManager.retrieveTexture("Block"))
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
                    where unit != .EmptySpace {
                        var texture: SKTexture
                        if unit == .Agent {
                            texture = TextureManager.agentUpTexture
                        } else {
                            texture = TextureManager.retrieveTexture(unit.spriteName)
                        }
                        let sprite = unit.spriteClass.init(texture: texture)
                        sprite.position = pointFor(row, column: column)
                        sprite.size = blockSize
                        unitsLayer.addChild(sprite)
                        if let sprite = sprite as? AgentNode {
                            sprite.gameScene = self
                            sprite.row = row
                            sprite.column = column
                            activeAgentNodes.append(sprite)
                        }
                }
            }
        }
    }

    // Convert a row, column pair into a CGPoint relative
    // to unitsLayer
    private func pointFor(row: Int, column: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*blockWidth,
            y: CGFloat(row)*blockHeight
        )
    }
}
