//
//  GameScene.swift
//  FinalProject
//
//  Created by louis on 12/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

struct PlayingMapSceneConstants {
    struct LabelText {
        static let play = "Play"
        static let pause = "Pause"
        static let reset = "Reset"
    }
    struct ButtonSpriteName {
        static let play = "play"
        static let pause = "pause"
        static let reset = "rewind"
        static let back = "back"
    }
}

class PlayingMapScene: StaticMapScene {
    var running = false
    var movesLeft: Int
    weak var playingMapController: PlayingMapViewController!
    var programSupplier: ProgramSupplier!
    var programRetrieved = false
    var gameEnded = false
    var playButton: SKButton!

    var timeOfLastMove: CFTimeInterval = 0.0
    let timePerMove: CFTimeInterval = 1.0

    var buttonSize: CGSize {
        return CGSize(
            width: GlobalConstants.Dimension.blockWidth*1.5,
            height: GlobalConstants.Dimension.blockHeight*1.5
        )
    }
    lazy var playLabel: SKSpriteNode = {
        return SKSpriteNode(
            texture: TextureManager.retrieveTexture(PlayingMapSceneConstants.ButtonSpriteName.play),
            size: self.buttonSize
        )
    }()
    lazy var pauseLabel: SKSpriteNode = {
        return SKSpriteNode(
            texture: TextureManager.retrieveTexture(PlayingMapSceneConstants.ButtonSpriteName.pause),
            size: self.buttonSize
        )
    }()


    override init(size: CGSize, zoomLevel: CGFloat, map: Map) {
        self.movesLeft = 11
        super.init(size: size, zoomLevel: zoomLevel, map: map)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not used")
    }

    override func update(currentTime: CFTimeInterval) {
        if currentTime - timeOfLastMove < timePerMove {
            return
        }
        if movesLeft == 0 || mapNode.activeAgentNodes.isEmpty {
            running = false
            return
        }
        if !running {
            return
        }
        moveActiveAgents()
        decrementMovesLeft()
        timeOfLastMove = currentTime
        if gameEnded {
            toggleRun()
        }
    }

    override func setup() {
        super.setup()
        setupButtons()
    }

    func toggleRun() {
        if !programRetrieved {
            for agent in mapNode.activeAgentNodes {
                if let program = programSupplier.retrieveProgram() {
                    agent.delegate = Interpreter(program: program)
                }
            }
        }
        programRetrieved = true
        if running {
            running = false
            playButton.setDefaultButton(playLabel)
        } else {
            running = true
            playButton.setDefaultButton(pauseLabel)
        }
    }

    func reset() {
        playingMapController.reset()
    }

    func goBack() {
        playingMapController.goBack()
    }

    func setupButtons() {
        // Setup Play button
        playButton = SKButton(defaultButton: playLabel)
        playButton.addTarget(self, selector: #selector(PlayingMapScene.toggleRun))
        playButton.position = CGPoint(
            x: 0.0,
            y: -300.0
        )
        addNodeToOverlay(playButton)

        // Setup Reset button
        let resetLabel = SKSpriteNode(imageNamed: PlayingMapSceneConstants.ButtonSpriteName.reset)
        resetLabel.size = buttonSize
        let resetButton = SKButton(defaultButton: resetLabel)
        resetButton.addTarget(self, selector: #selector(PlayingMapScene.reset))
        resetButton.position = CGPoint(
            x: 80.0,
            y: -300.0
        )
        addNodeToOverlay(resetButton)


        // Setup Back Button
        let backLabel = SKSpriteNode(imageNamed: PlayingMapSceneConstants.ButtonSpriteName.back)
        backLabel.size = buttonSize
        let backButton = SKButton(defaultButton: backLabel)
        backButton.addTarget(self, selector: #selector(PlayingMapScene.goBack))
        backButton.position = CGPoint(
            x: -200.0,
            y: -300.0
        )
        addNodeToOverlay(backButton)
    }

    private func moveActiveAgents() {
        var nextActiveAgentNodes = [AgentNode]()
        for agentNode in mapNode.activeAgentNodes {
            // If agent hasnt reached toilet, add it to the next list
            if let result = agentNode.runNextAction() {
                if result {
                    agentNode.runWinningAnimation()
                } else {
                    agentNode.runLosingAnimation()
                }
                gameEnded = true
            } else {
                if gameEnded {

                } else {
                    nextActiveAgentNodes.append(agentNode)
                }
            }
        }
        mapNode.activeAgentNodes = nextActiveAgentNodes
    }

    private func decrementMovesLeft() {
        movesLeft -= 1
        if let node = hudLayer.childNodeWithName(StaticMapSceneConstants.NodeNames.movesLeftLabel)
            as? SKLabelNode {
            node.text = "Moves left: \(movesLeft)"
        }

    }
}
