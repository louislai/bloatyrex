//
//  LevelDesigningViewController.swift
//  FinalProject
//
//  Created by Melvin Tan Jun Keong on 14/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import UIKit
import SpriteKit

class LevelDesigningViewController: UIViewController {

    var scene: LevelDesigningMapScene!
    var map = Map(numberOfRows: 6, numberOfColumns: 6)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the view.
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        skView.showsFPS = true
        skView.ignoresSiblingOrder = true

        // Create and configure the scene.
        scene = LevelDesigningMapScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill

        // Load the map
        scene.map = map
        scene.levelDesigningViewController = self
        scene.setup()

        // Present the scene.
        skView.presentScene(scene)
    }
}
