//
//  PannableScene.swift
//  FinalProject
//
//  Created by Tham Zheng Yi on 17/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation
import SpriteKit

class PannableScene: SKScene {
    var content: SKNode?
    var viewpoint: SKNode?

    override func didMoveToView(view: SKView) {
        // set up the viewpoint
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.content = SKNode()
        self.viewpoint = SKNode()
        self.content?.name = "content"
        self.viewpoint?.name = "viewpoint"
        self.content?.addChild(viewpoint!)
    }
}
