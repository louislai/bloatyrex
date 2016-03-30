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
    struct ButtonSpriteName {
        static let play = "play"
        static let pause = "pause"
        static let reset = "stop"
        static let back = "back"
    }
}

class PlayingMapScene: PannableScene {
    var map: Map!
    var running = false
    let blocksLayer = SKNode()
    let unitsLayer = SKNode()
    let hudLayer = SKNode()
    var activeAgentNodes = [AgentNode]()
    var originalMovesLeft = 11
    var movesLeft = 0
    weak var playingMapController: PlayingMapViewController!
    var programSupplier: ProgramSupplier!
    var programRetrieved = false
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

    var timeOfLastMove: CFTimeInterval = 0.0
    let timePerMove: CFTimeInterval = 1.0

    init(size: CGSize, zoomLevel: CGFloat) {
        super.init(size: size, zoomLevel: zoomLevel)
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
        if movesLeft == 0 || activeAgentNodes.isEmpty {
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
            x: -GlobalConstants.Dimension.blockWidth * CGFloat(numberOfColumns) / 2,
            y: -GlobalConstants.Dimension.blockHeight * CGFloat(numberOfRows) / 2
        )

        // The blocksLayer represent the shape of the map.
        // Each block is a square
        blocksLayer.position = layerPosition
        addNodeToContent(blocksLayer)

        // This layer holds the MapUnit sprites. The positions of these sprites
        // are relative to the unitsLayer's bottom-left corner.
        unitsLayer.position = layerPosition
        addNodeToContent(unitsLayer)
        addNodeToOverlay(hudLayer)
        addBlocks()
        setupMapUnits()
        setupHud()
        setupButtons()
    }

    func run() {
        guard !programRetrieved else {
            resetAndRun()
            return
        }
        for agent in activeAgentNodes {
            if let program = programSupplier.retrieveProgram() {
                agent.delegate = Interpreter(program: program)
            }
        }
        programRetrieved = true
        running = true
    }

    func pause() {
        running = false
    }

    func reset() {
        playingMapController.reset()
    }

    func resetAndRun() {
        playingMapController.resetAndRun()
    }

    func goBack() {
        playingMapController.goBack()
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
        let movesLeftLabel = SKLabelNode(text: "Moves Left: ")
        movesLeftLabel.name = PlayingMapSceneConstants.NodeNames.movesLeftLabel

        let layerPosition = CGPoint(
            x: -movesLeftLabel.frame.size.width/2,
            y: 300.0
        )
        // 2
        movesLeftLabel.fontColor = SKColor.blueColor()
        movesLeftLabel.text = String(format: "Moves Left: %d", originalMovesLeft)

        // 3
        movesLeftLabel.position = layerPosition
        hudLayer.addChild(movesLeftLabel)

        movesLeft = originalMovesLeft
    }

    func setupButtons() {
        // Setup Play button
        let playLabel = SKSpriteNode(imageNamed: PlayingMapSceneConstants.ButtonSpriteName.play)
        playLabel.size = blockSize
        let playButton = SKButton(defaultButton: playLabel)
        playButton.addTarget(self, selector: #selector(PlayingMapScene.run))
        playButton.position = CGPoint(
            x: -80.0,
            y: -300.0
        )
        addNodeToOverlay(playButton)

        // Setup Pause button
        let pauseLabel = SKSpriteNode(imageNamed: PlayingMapSceneConstants.ButtonSpriteName.pause)
        pauseLabel.size = blockSize
        let pauseButton = SKButton(defaultButton: pauseLabel)
        pauseButton.addTarget(self, selector: #selector(PlayingMapScene.pause))
        pauseButton.position = CGPoint(
            x: 0.0,
            y: -300.0
        )
        addNodeToOverlay(pauseButton)

        // Setup Reset button
        let resetLabel = SKSpriteNode(imageNamed: PlayingMapSceneConstants.ButtonSpriteName.reset)
        resetLabel.size = blockSize
        let resetButton = SKButton(defaultButton: resetLabel)
        resetButton.addTarget(self, selector: #selector(PlayingMapScene.reset))
        resetButton.position = CGPoint(
            x: 80.0,
            y: -300.0
        )
        addNodeToOverlay(resetButton)


        // Setup Back Button
        let backLabel = SKSpriteNode(imageNamed: PlayingMapSceneConstants.ButtonSpriteName.back)
        backLabel.size = blockSize
        let backButton = SKButton(defaultButton: backLabel)
        backButton.addTarget(self, selector: #selector(PlayingMapScene.goBack))
        backButton.position = CGPoint(
            x: -200.0,
            y: -300.0
        )
        addNodeToOverlay(backButton)
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
        if let node = hudLayer.childNodeWithName(PlayingMapSceneConstants.NodeNames.movesLeftLabel)
            as? SKLabelNode {
                node.text = String(format: "Moves Left: %d", movesLeft)
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
