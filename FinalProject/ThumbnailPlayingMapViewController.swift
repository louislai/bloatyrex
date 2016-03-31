//
//  ThumbnailPlayingMapViewController.swift
//  FinalProject
//
//  Created by louis on 30/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import UIKit
import SpriteKit

class ThumbnailPlayingMapViewController: UIViewController {
    var map: Map!

    override func didMoveToParentViewController(parent: UIViewController?) {
        super.didMoveToParentViewController(parent)
        view.backgroundColor = UIColor.blueColor()
        print(view.bounds.size)
        // Configure the view
        setUpScene()
    }


    func setUpScene() {
        print(view.bounds.size)
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true

        // Present the scene.
        let scene = StaticMapScene(size: view.bounds.size, zoomLevel: 1, map: map)
        scene.setup()
        skView.presentScene(scene)
    }
}