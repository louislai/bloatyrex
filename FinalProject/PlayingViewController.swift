//
//  ViewController.swift
//  FinalProject
//
//  Created by Tham Zheng Yi on 8/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import UIKit
import SpriteKit

class PlayingViewController: UIViewController {

    var scene: PlayingMapScene!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the view.
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        skView.showsFPS = true
        skView.ignoresSiblingOrder = true

        // Create and configure the scene.
        scene = PlayingMapScene(size: skView.bounds.size)
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
        scene.originalMap = map
        scene.setup()

        // Present the scene.
        skView.presentScene(scene)
    }

    @IBAction func runButtonTapped(sender: UIButton) {
        scene.run()
    }

    @IBAction func pauseButtonTapped(sender: UIButton) {
        scene.pause()
    }

    @IBAction func resetButtonTapped(sender: UIButton) {
        scene.reset()
    }
}
