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

    /// Initialise the scene with a given size, and optional scale and overlay z position.
    /// Zoom level is how far the camera is zoomed in, e.g. 1 is no zoom and 2 is 2x zoom.
    init(size: CGSize, zoomLevel: CGFloat = 1, overlayZPosition: CGFloat = 10) {
        super.init(size: size)
        viewpoint.xScale = 1.0 / zoomLevel
        viewpoint.yScale = 1.0 / zoomLevel
        overlay.zPosition = overlayZPosition
    }

    override func didMoveToView(view: SKView) {
        // set up the viewpoint
        self.addChild(content)
        viewpoint.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(viewpoint)
        self.camera = viewpoint
        viewpoint.addChild(overlay)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Handle the panning movement of the scene.
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            // calculate the distance panned
            let newPoint = touch.locationInNode(self)
            let previousPoint = touch.previousLocationInNode(self)
            moveViewPointBy(previousPoint.x - newPoint.x,
                verticalDisplacement: previousPoint.y - newPoint.y)
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

    /// Moves the viewpoint by a given X and Y value.
    private func moveViewPointBy(horizontalDisplacement: CGFloat, verticalDisplacement: CGFloat) {
        self.viewpoint.runAction(SKAction.moveByX(horizontalDisplacement,
            y: verticalDisplacement, duration: 0.1))
    }
}
