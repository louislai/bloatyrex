//
//  PlayingMapScene.swift
//  FinalProject
//
//  Created by louis on 12/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// Inherits from StaticMapScene
/// The dynamic scene that executes the game
///
/// Public Properties:
/// - programSupplier: the supplier of the program tree to be fed to the agent

import SpriteKit

class PlayingMapScene: StaticMapScene {
    weak var programSupplier: ProgramSupplier!

    private var newRoundStarted = false
    private var playButton: SKButton!
    private var resetButton: SKButton!
    private var running = false
    private var movesLeft = 0
    private var gameWon: Bool?
    private var timeOfLastMove: CFTimeInterval = 0.0
    private let isPlayingPresetMap: Bool
    private let scorer: Scorer = DefaultGameScorer()
    private var buttonSize: CGSize {
        return CGSize(
            width: PlayingMapSceneConstants.buttonDimension,
            height: PlayingMapSceneConstants.buttonDimension
        )
    }
    private lazy var playLabel: SKSpriteNode = {
        return SKSpriteNode(
            texture: TextureManager.retrieveTexture(PlayingMapSceneConstants.ButtonSpriteName.play),
            size: self.buttonSize
        )
    }()
    private lazy var pauseLabel: SKSpriteNode = {
        return SKSpriteNode(
            texture: TextureManager.retrieveTexture(PlayingMapSceneConstants.ButtonSpriteName.pause),
            size: self.buttonSize
        )
    }()

    override var hudFontSize: CGFloat {
        return 30.0
    }
    override var movesLeftLabelPosition: CGPoint {
        return CGPoint(
            x: 130,
            y: 300.0
        )
    }
    override var levelNameLabelPosition: CGPoint {
        return CGPoint(
            x: -250.0,
            y: 300.0
        )
    }

    override init(size: CGSize, zoomLevel: CGFloat, map: Map, levelName: String) {
        if let _ = map as? PresetMap {
            self.isPlayingPresetMap = true
        } else {
            self.isPlayingPresetMap = false
        }
        super.init(size: size, zoomLevel: zoomLevel, map: map, levelName: levelName)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not used")
    }

    /// The game loop, execute action every timePerMove constant
    /// In each execution, the engine will first check if the game is still ongoing
    /// then execute the monters' actions, followed by the agent
    /// and then check for game end condition
    override func update(currentTime: CFTimeInterval) {
        if currentTime - timeOfLastMove < PlayingMapSceneConstants.timePerMove {
            return
        }
        if mapNode.activeAgentNodes.isEmpty {
            running = false
            return
        }
        if running && movesLeft == 0 {
            handleLosing()
            return
        }
        if !running {
            return
        }
        moveMonsters()
        moveActiveAgents()
        decrementMovesLeft()
        timeOfLastMove = currentTime
        if let gameWon = gameWon {
            if gameWon {
                handleWinning()
            } else {
                handleLosing()
            }
        }
    }

    /// Setup the game components
    override func setup() {
        super.setup()
        setupButtons()
        // Display moves left
        self.movesLeft = mapNode.originalMovesLeft
        if let node = hudLayer.childNodeWithName(StaticMapSceneConstants.NodeNames.movesLeftLabel)
            as? SKLabelNode {
                node.text = "MOVES LEFT: \(movesLeft)"
        }
        if let node = hudLayer.childNodeWithName(StaticMapSceneConstants.NodeNames.levelNameLabel)
            as? SKLabelNode {
                node.horizontalAlignmentMode = .Left
        }

    }

    /// Toggle the play/pause state of the play button
    func toggleRun() {
        if running {
            pause()
        // When user click the button after game ended
        } else if gameWon != nil {
            resetAndRun()
        } else {
            run()
        }
    }

    /// Send notification to reset the game
    func reset() {
        NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.Notification.gameReset, object: self)
    }

    /// Send notificaiotn to reset the game and re-run the game right away
    func resetAndRun() {
        NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.Notification.gameResetAndRun, object: self)
    }

    private func addRetryText() {
        let arrowSize = CGSize(
        width: buttonSize.width*2.0,
        height: buttonSize.height*2.0
        )
        let arrowNode = SKSpriteNode(imageNamed: "arrow-over")
        arrowNode.size = arrowSize
        arrowNode.position = CGPoint(
            x: resetButton.position.x+buttonSize.width*1.5,
            y: resetButton.position.y+arrowSize.height/3.0
        )
        addNodeToOverlay(arrowNode)

        let retryText = SKLabelNode(text: PlayingMapSceneConstants.LabelText.resetHint)
        retryText.fontColor = UIColor.redColor()
        retryText.fontName = GlobalConstants.Font.defaultNameBold
        retryText.position = CGPoint(
            x: arrowNode.position.x-arrowNode.frame.size.width/4.0,
            y: arrowNode.position.y + buttonSize.height*1.1
        )
        addNodeToOverlay(retryText)
        let waitAction = SKAction.waitForDuration(0.2)
        let showHideAction = SKAction.repeatActionForever(
            SKAction.sequence([
                waitAction,
                SKAction.hide(),
                waitAction,
                SKAction.unhide()
                ])
        )
        arrowNode.runAction(showHideAction)
    }

    private func prepareNewRound() {
        for door in mapNode.doorNodes {
            door.randomizeDoor()
        }
        for agent in mapNode.activeAgentNodes {
            if let program = programSupplier.retrieveProgram() {
                agent.delegate = Interpreter(program: program)
            }
        }
        for monster in mapNode.monsterNodes {
            monster.setSleeping()
        }
    }

    private func handleWinning() {
        pause()
        // Calculate score if map is a presetMap
        var info = [String: AnyObject]()
        info[GlobalConstants.Notification.gameWonInfoIsPlayingPresetMap] = isPlayingPresetMap
        if isPlayingPresetMap {
            let criteria = [ScoreCriterion.MovesLeft(movesLeft)]
            let score = scorer.criteriaToScore(criteria)
            let rating = (mapNode.map as! PresetMap).getRatingForScore(score)
            info[GlobalConstants.Notification.gameWonInfoRating] = rating
        }

        NSNotificationCenter
            .defaultCenter()
            .postNotificationName(
                GlobalConstants.Notification.gameWon,
                object: self,
                userInfo: info
            )
    }

    private func handleLosing() {
        pause()
        addRetryText()
    }

    private func moveActiveAgents() {
        var nextActiveAgentNodes = [AgentNode]()
        var shouldWin = true
        var shouldLose = false
        for agentNode in mapNode.activeAgentNodes {
            // If agent hasnt reached toilet, add it to the next list
            switch agentNode.runNextAction() {
            case .NoResult:
                if shouldLose {
                    agentNode.runLosingAnimation()
                } else {
                    shouldWin = false
                    nextActiveAgentNodes.append(agentNode)
                }
            case .Win: agentNode.runWinningAnimation()
            case .Lose:
                agentNode.runLosingAnimation()
                shouldWin = false
                shouldLose = true
            }
        }
        if shouldWin {
            gameWon = true
        } else if shouldLose {
            gameWon = false
        }
        mapNode.activeAgentNodes = nextActiveAgentNodes
    }

    func run() {
        if !newRoundStarted {
            prepareNewRound()
        }
        newRoundStarted = true
        running = true
        playButton.setDefaultButton(pauseLabel)
    }

    private func pause() {
        running = false
        playButton.setDefaultButton(playLabel)
    }

    private func moveMonsters() {
        for monster in mapNode.monsterNodes {
            monster.nextAction()
        }
    }

    private func decrementMovesLeft() {
        movesLeft -= 1
        if let node = hudLayer.childNodeWithName(StaticMapSceneConstants.NodeNames.movesLeftLabel)
            as? SKLabelNode {
            node.text = "MOVES LEFT: \(movesLeft)"
        }
    }

    private func setupButtons() {
        // Setup Play button
        playButton = SKButton(defaultButton: playLabel)
        playButton.addTarget(self, selector: #selector(PlayingMapScene.toggleRun))
        playButton.position = CGPoint(
            x: 0.0,
            y: PlayingMapSceneConstants.buttonYPosition
        )
        addNodeToOverlay(playButton)

        // Setup Reset button
        let resetLabel = SKSpriteNode(imageNamed: PlayingMapSceneConstants.ButtonSpriteName.reset)
        resetLabel.size = buttonSize
        resetButton = SKButton(defaultButton: resetLabel)
        resetButton.addTarget(self, selector: #selector(PlayingMapScene.reset))
        resetButton.position = CGPoint(
            x: 80.0,
            y: PlayingMapSceneConstants.buttonYPosition
        )
        addNodeToOverlay(resetButton)
    }

}
