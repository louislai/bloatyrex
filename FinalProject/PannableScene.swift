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
    private var content: SKNode!
    private var overlay: SKNode!
    private var viewpoint: SKCameraNode!

    override init(size: CGSize) {
        super.init(size: size)
        content = SKNode()
        overlay = SKNode()
        viewpoint = SKCameraNode()
        // set up the viewpoint
        viewpoint.xScale = 0.25
        viewpoint.yScale = 0.25
        self.camera = viewpoint
    }

    override func didMoveToView(view: SKView) {
        viewpoint.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))

        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(self.content)
        self.content.name = "content"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            moveViewpointToPoint(touch.locationInNode(self))
        }
    }

    /// Adds a node to be part of the content that is pannable.
    func addNodeToContent(node: SKNode) {
        content.addChild(node)
    }

    /// Adds a node to the overlay
    func addNodeToOverlay(node: SKNode) {
        overlay.addChild(node)
    }

    /// Moves the viewpoint over the scene to the given point.
    func moveViewpointToPoint(point: CGPoint) {
        self.viewpoint.position = point
    }
}
