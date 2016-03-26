//
//  ViewController.swift
//  FinalProject
//
//  Created by Tham Zheng Yi on 8/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import UIKit
import SpriteKit

class PlayingMapViewController: UIViewController {

    var map: Map!
    var scene: PlayingMapScene!

    override func didMoveToParentViewController(parent: UIViewController?) {
        super.didMoveToParentViewController(parent)
        print(view.bounds.size)
        // Configure the view
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true

        // Present the scene.
        skView.presentScene(newScene())
    }

    func newScene() -> PlayingMapScene {
        let skView = view as! SKView

        // Create and configure the scene
        scene = PlayingMapScene(size: skView.bounds.size, zoomLevel: 1)
        scene.scaleMode = .AspectFill

        // Load the map
        scene.map = map
        scene.resetDelegate = self
        scene.setup()

        return scene
    }
}

extension PlayingMapViewController: ResetDelegate {
    func reset() {
        let skView = view as! SKView

        let transition = SKTransition.crossFadeWithDuration(0.0)
        scene = newScene()
        skView.presentScene(scene, transition: transition)
    }
}
