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

    override func didMoveToParentViewController(parent: UIViewController?) {
        super.didMoveToParentViewController(parent)
        print(view.bounds.size)
        // Configure the view
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill

        // Present the scene.
        skView.presentScene(newScene())
    }

    func newScene() -> PlayingMapScene {
        let skView = view as! SKView

        // Create and configure the scene
        let scene = PlayingMapScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill

        // Load the map
        let map = Map(numberOfRows: 3, numberOfColumns: 9)
        map.setMapUnitAt(.Agent, row: 0, column: 0)
        map.setMapUnitAt(.Wall, row: 0, column: 1)
        map.setMapUnitAt(.Goal, row: 0, column: 7)
        for i in 0..<9 {
            map.setMapUnitAt(.Wall, row: 2, column: i)
        }
        for i in 0..<3 {
            map.setMapUnitAt(.Wall, row: i, column: 8)
        }
        scene.map = map
        scene.resetDelegate = self
        scene.setup()

        return scene
    }
}

extension PlayingMapViewController: ResetDelegate {
    func reset() {
        let skView = view as! SKView

        let transition = SKTransition.crossFadeWithDuration(0.5)
        skView.presentScene(newScene(), transition: transition)
    }
}
