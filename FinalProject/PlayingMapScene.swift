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
        static let reset = "stop"
        static let back = "back"
    }
}

class PlayingMapScene: StaticMapScene {
    var running = false
    var movesLeft: Int
    weak var playingMapController: PlayingMapViewController!
    var programSupplier: ProgramSupplier!
    var programRetrieved = false

    var timeOfLastMove: CFTimeInterval = 0.0
    let timePerMove: CFTimeInterval = 1.0

    var buttonSize: CGSize {
        return CGSize(
            width: GlobalConstants.Dimension.blockWidth*1.5,
            height: GlobalConstants.Dimension.blockHeight*2
        )
    }

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
    }

    override func setup() {
        super.setup()
        setupButtons()
    }

    func run() {
        guard !programRetrieved else {
            resetAndRun()
            return
        }
        for agent in mapNode.activeAgentNodes {
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

    func setupButtons() {
        // Setup Play button
        let playLabel = SKSpriteNode(imageNamed: PlayingMapSceneConstants.ButtonSpriteName.play)
        playLabel.size = buttonSize
        let playButton = SKButton(defaultButton: playLabel)
        playButton.addTarget(self, selector: #selector(PlayingMapScene.run))
        playButton.position = CGPoint(
            x: -80.0,
            y: -300.0
        )
        addNodeToOverlay(playButton)

        // Setup Pause button
        let pauseLabel = SKSpriteNode(imageNamed: PlayingMapSceneConstants.ButtonSpriteName.pause)
        pauseLabel.size = buttonSize
        let pauseButton = SKButton(defaultButton: pauseLabel)
        pauseButton.addTarget(self, selector: #selector(PlayingMapScene.pause))
        pauseButton.position = CGPoint(
            x: 0.0,
            y: -300.0
        )
        addNodeToOverlay(pauseButton)

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
            if !agentNode.runNextAction() {
                nextActiveAgentNodes.append(agentNode)
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
