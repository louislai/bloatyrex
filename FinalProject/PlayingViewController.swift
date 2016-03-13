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
        let map = Map(numberOfRows: 2, numberOfColumns: 8)
        map.setMapUnitAt(.Agent, row: 0, column: 0)
        map.setMapUnitAt(.Wall, row: 0, column: 1)
        map.setMapUnitAt(.Goal, row: 0, column: 7)
        scene.map = map
        scene.setup()
        let program = Program.MultipleStatement(
            Statement.ActionStatement(Action.Forward),
            Program.MultipleStatement(
                Statement.ActionStatement(Action.RotateRight),
                Program.MultipleStatement(
                    Statement.ActionStatement(Action.Forward),
                    Program.MultipleStatement(
                        Statement.ActionStatement(Action.Forward),
                        Program.MultipleStatement(
                            Statement.ActionStatement(Action.Forward),
                            Program.MultipleStatement(
                                Statement.ActionStatement(Action.Forward),
                                Program.MultipleStatement(
                                    Statement.ActionStatement(Action.Forward),
                                    Program.MultipleStatement(
                                        Statement.ActionStatement(Action.Forward),
                                        Program.MultipleStatement(
                                            Statement.ActionStatement(Action.Forward),
                                            Program.MultipleStatement(
                                                Statement.ActionStatement(Action.RotateRight),
                                                Program.SingleStatement(
                                                    Statement.ActionStatement(Action.Forward)
                                                )
                                            )
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )

        // Present the scene.
        skView.presentScene(scene)

        // Let's start the game!
        beginGame()
    }

    func beginGame() {
//        scene.begin()
    }
}
