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
    static let buttonYPosition = CGFloat(-334)
    static let buttonDimension = CGFloat(60)
}

class PlayingMapScene: StaticMapScene {
    var running = false
    var movesLeft = 0
    weak var programSupplier: ProgramSupplier!
    var newRoundStarted = false
    var gameWon: Bool?
    var playButton: SKButton!
    var resetButton: SKButton!

    var timeOfLastMove: CFTimeInterval = 0.0
    let timePerMove: CFTimeInterval = 1.0
    let isPlayingPresetMap: Bool
    let scorer: Scorer = DefaultGameScorer()

    var buttonSize: CGSize {
        return CGSize(
            width: PlayingMapSceneConstants.buttonDimension,
            height: PlayingMapSceneConstants.buttonDimension
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
        if let _ = map as? PresetMap {
            self.isPlayingPresetMap = true
        } else {
            self.isPlayingPresetMap = false
        }
        super.init(size: size, zoomLevel: zoomLevel, map: map)
        self.movesLeft = mapNode.originalMovesLeft
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not used")
    }

    override func update(currentTime: CFTimeInterval) {
        if currentTime - timeOfLastMove < timePerMove {
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

    override func setup() {
        super.setup()
        setupButtons()
        // Display moves left
        self.movesLeft = mapNode.originalMovesLeft
        if let node = hudLayer.childNodeWithName(StaticMapSceneConstants.NodeNames.movesLeftLabel)
            as? SKLabelNode {
            node.text = "MOVES LEFT: \(movesLeft)"
        }
    }

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

    func run() {
        if !newRoundStarted {
            prepareNewRound()
        }
        newRoundStarted = true
        running = true
        playButton.setDefaultButton(pauseLabel)
    }

    func pause() {
        running = false
        playButton.setDefaultButton(playLabel)
    }

    func reset() {
        NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.Notification.gameReset, object: self)
    }

    func resetAndRun() {
        NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.Notification.gameResetAndRun, object: self)
    }

    func setupButtons() {
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

    func addRetryText() {

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

        let retryText = SKLabelNode(text: "Rewind to retry")
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
            if let result = agentNode.runNextAction() {
                if result {
                    agentNode.runWinningAnimation()
                } else {
                    agentNode.runLosingAnimation()
                    shouldWin = false
                    shouldLose = true
                }
            } else {
                if shouldLose {
                    agentNode.runLosingAnimation()
                } else {
                    shouldWin = false
                    nextActiveAgentNodes.append(agentNode)
                }
            }
        }
        if shouldWin {
            gameWon = true
        } else if shouldLose {
            gameWon = false
        }
        mapNode.activeAgentNodes = nextActiveAgentNodes
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
}
