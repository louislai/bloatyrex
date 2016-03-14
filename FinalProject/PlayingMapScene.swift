//
//  GameScene.swift
//  FinalProject
//
//  Created by louis on 12/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

struct PlayingMapSceneConstants {
    static let zPositionFront: CGFloat = 2
    static let zPositionBack: CGFloat = 1
    struct NodeNames {
        static let movesLeftLabel = "movesLeft"
    }
    struct LabelText {
        static let play = "Play"
        static let pause = "Pause"
        static let reset = "Reset"
    }
}

class PlayingMapScene: SKScene {
    var map: Map!
    var running = false
    let blocksLayer = SKNode()
    let unitsLayer = SKNode()
    var activeAgentNodes = [AgentNode]()
    var originalMovesLeft = 11
    var movesLeft = 0
    var resetDelegate: ResetDelegate!
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

    var timeOfLastMove: CFTimeInterval = 0.0
    let timePerMove: CFTimeInterval = 1.0

    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not used")
    }

    override func update(currentTime: CFTimeInterval) {
        if currentTime - timeOfLastMove < timePerMove {
            return
        }
        if movesLeft == 0 {
            running = false
            return
        }
        if !running {
            return
        }

        moveActiveAgents()
        decrementMovesLeft()
        timeOfLastMove = currentTime
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
        setupHud()
        setupButtons()
    }

    func run() {
        running = true
    }

    func pause() {
        running = false
    }

    func reset() {
        resetDelegate.reset()
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

    func setupHud() {
        // 1
        let movesLeftLabel = SKLabelNode(fontNamed: "Courier")
        movesLeftLabel.fontSize = 65
        movesLeftLabel.name = PlayingMapSceneConstants.NodeNames.movesLeftLabel

        let layerPosition = CGPoint(
            x: -movesLeftLabel.frame.size.width/2,
            y: 300.0
        )
        // 2
        movesLeftLabel.fontColor = SKColor.greenColor()
        movesLeftLabel.text = String(format: "Moves Left: %d", originalMovesLeft)

        // 3
        movesLeftLabel.position = layerPosition
        addChild(movesLeftLabel)

        movesLeft = originalMovesLeft
    }

    func setupButtons() {
        // Setup Play button
        let playLabel = SKLabelNode(text: PlayingMapSceneConstants.LabelText.play)
        playLabel.fontSize = 65
        playLabel.fontColor = SKColor.greenColor()
        playLabel.fontName = "Courier"
        let playButton = SKButton(defaultButton: playLabel)
        playButton.action = {
            self.run()
        }
        playButton.position = CGPoint(
            x: -300.0,
            y: -300.0
        )
        addChild(playButton)

        // Setup Pause button
        let pauseLabel = SKLabelNode(text: PlayingMapSceneConstants.LabelText.pause)
        pauseLabel.fontSize = 65
        pauseLabel.fontColor = SKColor.greenColor()
        pauseLabel.fontName = "Courier"
        let pauseButton = SKButton(defaultButton: pauseLabel)
        pauseButton.action = {
            self.pause()
        }
        pauseButton.position = CGPoint(
            x: 0.0,
            y: -300.0
        )
        addChild(pauseButton)

        // Setup Reset button
        let resetLabel = SKLabelNode(text: PlayingMapSceneConstants.LabelText.reset)
        resetLabel.fontSize = 65
        resetLabel.fontColor = SKColor.greenColor()
        resetLabel.fontName = "Courier"
        let resetButton = SKButton(defaultButton: resetLabel)
        resetButton.action = {
            self.reset()
        }
        resetButton.position = CGPoint(
            x: 300.0,
            y: -300.0
        )
        addChild(resetButton)
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
                        sprite.zPosition = PlayingMapSceneConstants.zPositionBack
                        if let sprite = sprite as? AgentNode {
                            sprite.zPosition = PlayingMapSceneConstants.zPositionFront
                            sprite.gameScene = self
                            sprite.row = row
                            sprite.column = column
                            sprite.originalProgram = Sample.sampleProgram3
                            sprite.delegate = Interpreter(program: Sample.sampleProgram3)
                            activeAgentNodes.append(sprite)
                        }
                        unitsLayer.addChild(sprite)
                }
            }
        }
    }

    private func moveActiveAgents() {
        var nextActiveAgentNodes = [AgentNode]()
        for agentNode in activeAgentNodes {
            // If agent hasnt reached toilet, add it to the next list
            if !agentNode.runNextAction() {
                nextActiveAgentNodes.append(agentNode)
            }
        }
        activeAgentNodes = nextActiveAgentNodes
    }

    private func decrementMovesLeft() {
        movesLeft -= 1
        if let node = childNodeWithName(PlayingMapSceneConstants.NodeNames.movesLeftLabel)
            as? SKLabelNode {
                node.text = String(format: "Moves Left: %d", movesLeft)
        }
    }

    // Convert a row, column pair into a CGPoint relative
    // to unitsLayer
    func pointFor(row: Int, column: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*blockWidth,
            y: CGFloat(row)*blockHeight
        )
    }
}
