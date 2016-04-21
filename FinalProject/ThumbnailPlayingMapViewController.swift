//
//  ThumbnailPlayingMapViewController.swift
//  FinalProject
//
//  Created by louis on 30/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// ThumbnailPlayingMapViewController serves to show the player a small thumbnail
/// of the map in the programming view

import UIKit
import SpriteKit

class ThumbnailPlayingMapViewController: UIViewController {
    var map: Map!
    var levelName: String!

    override func didMoveToParentViewController(parent: UIViewController?) {
        super.didMoveToParentViewController(parent)
        view.backgroundColor = UIColor.blueColor()
        // Configure the view
        setUpScene()
    }

    func setUpScene() {
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        skView.ignoresSiblingOrder = true

        // Present the scene.
        let scene = StaticMapScene(size: view.bounds.size, zoomLevel: 0.6, map: map, levelName: levelName)
        scene.setup()
        skView.presentScene(scene)
    }
}
