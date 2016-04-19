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
    var monsterNodes = [MonsterNode]()
    var goalNodes = [GoalNode]()
    var doorNodes = [DoorNode]()
    var originalMovesLeft = 0
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
                    unit.position = pointFor(row, column: column)
                    unit.size = blockSize
                    unit.zPosition = GlobalConstants.zPosition.back
                    if let agent = unit as? AgentNode {
                        agent.zPosition = GlobalConstants.zPosition.front
                        agent.mapNode = self
                        agent.row = row
                        agent.column = column
                        activeAgentNodes.append(agent)
                        // This is fine since only 1 agent
                        originalMovesLeft = agent.numberOfMoves
                    } else if let door = unit as? DoorNode {
                        doorNodes.append(door)
                    } else if let monster = unit as? MonsterNode {
                        monster.row = row
                        monster.column = column
                        monster.mapNode = self
                        monster.initializeTurnsUntilAwake()
                        monsterNodes.append(monster)
                    } else if let goal = unit as? GoalNode {
                        goalNodes.append(goal)
                    }
                    unitsLayer.addChild(unit)
                }
            }
        }
    }


    func isRowAndColumnSafeFromMonster(row: Int, column: Int, steps: Int = 0) -> Bool {
        if let monster = map.retrieveMapUnitAt(row+1, column: column) as? MonsterNode
            where monster.isAwake(steps) {
                monster.setOrientation(.Down)
                return false
        }
        if let monster = map.retrieveMapUnitAt(row-1, column: column) as? MonsterNode
            where monster.isAwake(steps) {
                monster.setOrientation(.Up)
                return false
        }
        if let monster = map.retrieveMapUnitAt(row, column: column+1) as? MonsterNode
            where monster.isAwake(steps) {
                monster.setOrientation(.Left)
                return false
        }
        if let monster = map.retrieveMapUnitAt(row, column: column-1) as? MonsterNode
            where monster.isAwake(steps) {
                monster.setOrientation(.Right)
                return false
        }
        return true
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
