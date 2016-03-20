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
    private var content = SKNode()
    private var overlay = SKNode()
    var viewpoint: SKCameraNode = SKCameraNode()

    init(size: CGSize, scale: CGFloat = 1, overlayZPosition: CGFloat = 10) {
        super.init(size: size)
        viewpoint.xScale = scale
        viewpoint.yScale = scale
        overlay.zPosition = overlayZPosition
    }

    override func didMoveToView(view: SKView) {
        // set up the viewpoint
        self.viewpoint.addChild(content)
        viewpoint.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        addChild(self.viewpoint)
        addChild(self.overlay)

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
        self.viewpoint.runAction(SKAction.moveTo(point, duration: 0.1))
    }
}
