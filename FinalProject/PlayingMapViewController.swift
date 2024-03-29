//
//  ViewController.swift
//  FinalProject
//
//  Created by Tham Zheng Yi on 8/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// PlayingMapViewController is reponsible for displaying the game execution
/// This is a child view controller segued from PlayingViewController
///
/// Public Properties:
/// - map: map of the level
/// - scene: the SKScene scene executing the game
/// - programSupplier: supply to program that will run the agent

import UIKit
import SpriteKit

class PlayingMapViewController: UIViewController {

    var map: Map!
    var scene: PlayingMapScene!
    var levelName: String!
    weak var programSupplier: ProgramSupplier!
    var fromProgrammingView = false

    override func didMoveToParentViewController(parent: UIViewController?) {
        super.didMoveToParentViewController(parent)

        print(view.bounds.size)
        // Configure the view
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        skView.ignoresSiblingOrder = true

        // Present the scene.
        skView.presentScene(newScene())
        if fromProgrammingView {
            resetAndRun()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerObservers()
    }

    private func newScene() -> PlayingMapScene {
        let skView = view as! SKView
        // Create and configure the scene
        scene = PlayingMapScene(
            size: skView.bounds.size,
            zoomLevel: 1,
            map: map.copy() as! Map,
            levelName: levelName
        )
        scene.scaleMode = .AspectFill

        // Load the map
        scene.programSupplier = self
        scene.setup()

        return scene
    }

    /// Observes the notifications from the game scene's reset and re-run events
    private func registerObservers() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(PlayingMapViewController.reset),
            name: GlobalConstants.Notification.gameReset,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(PlayingMapViewController.resetAndRun),
            name: GlobalConstants.Notification.gameResetAndRun,
            object: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

// MARK: These methods executes in response to the nofication sent by NotificationCenter
extension PlayingMapViewController {
    func reset() {
        let skView = view as! SKView

        let transition = SKTransition.crossFadeWithDuration(0.0)
        scene = newScene()
        skView.presentScene(scene, transition: transition)
    }

    func resetAndRun() {
        reset()
        let delay = Int64(NSEC_PER_SEC)/Int64(3)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay), dispatch_get_main_queue(), { () -> Void in
            self.scene.run()
        })
    }
}

// MARK: ProgramSupplier
extension PlayingMapViewController: ProgramSupplier {
    func retrieveProgram() -> Program? {
        return programSupplier.retrieveProgram()
    }
}
