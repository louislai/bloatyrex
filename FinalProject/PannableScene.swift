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
    private var viewpoint: SKCameraNode = SKCameraNode()
    private var initialScale: CGFloat
    private var maximumScale: CGFloat
    private var minimumScale: CGFloat

    /// Initialise the scene with a given size, and optional scale and overlay z position.
    /// zoomLevel is how far the camera is zoomed in, e.g. 1 is no zoom and 2 is 2x zoom.
    /// zoomRangeFactor denotes how much the zoom level can be adjusted. The default value of 2.0
    /// allows the zoom to be a max/min of 2.0 times larger/smaller than the original zoom level.
    init(size: CGSize, zoomLevel: CGFloat = 1, overlayZPosition: CGFloat = 10,
        zoomRangeFactor: CGFloat = 2.0) {
            initialScale = 1.0 / zoomLevel
            maximumScale = initialScale * zoomRangeFactor
            minimumScale = initialScale / zoomRangeFactor
            super.init(size: size)
            viewpoint.setScale(initialScale)
            overlay.zPosition = overlayZPosition
    }

    override func didMoveToView(view: SKView) {
        // set up the viewpoint
        self.addChild(content)
        viewpoint.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(viewpoint)
        self.camera = viewpoint
        viewpoint.addChild(overlay)
        let pinchRecognizer = UIPinchGestureRecognizer(target: self,
            action: Selector("handlePinch:"))
        self.view!.addGestureRecognizer(pinchRecognizer)
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
            var horizontalDisplacement = newPoint.x - previousPoint.x
            var verticalDisplacement = newPoint.y - previousPoint.y

            // bound the area within which the viewpoint can pan
            if horizontalDisplacement > 0 {
                let distanceToLeftBoundary = self.size.width / 2 + viewpoint.position.x
                horizontalDisplacement = min(distanceToLeftBoundary, horizontalDisplacement)

            } else if horizontalDisplacement < 0 {
                let distanceToRightBoundary = self.size.width / 2 - viewpoint.position.x
                horizontalDisplacement = -min(distanceToRightBoundary, -horizontalDisplacement)
            }
            if verticalDisplacement > 0 {
                var distanceToBottomBoundary = self.size.height / 2 + viewpoint.position.y
                distanceToBottomBoundary = max(distanceToBottomBoundary, 0)
                verticalDisplacement = min(distanceToBottomBoundary, verticalDisplacement)
            } else if verticalDisplacement < 0 {
                let distanceToTopBoundary = self.size.height / 2 - viewpoint.position.y
                verticalDisplacement = -min(distanceToTopBoundary, -verticalDisplacement)
            }

            // viewpoint moves in opposite direction from pan to simulate movement
            moveViewPointBy(-horizontalDisplacement, verticalDisplacement: -verticalDisplacement)
        }
    }

    func handlePinch(sender: UIPinchGestureRecognizer) {
        if sender.numberOfTouches() == 2 {
            let locationInView = sender.locationInView(sender.view)
            let zoomLocation = self.convertPointFromView(locationInView)
            if sender.state == .Changed {
                // The scale applied to the contents is the inverse of the camera node’s scale
                var newScale = viewpoint.xScale * (1.0 / sender.scale)
                if newScale < minimumScale {
                    newScale = minimumScale
                } else if newScale > maximumScale {
                    newScale = maximumScale
                }
                viewpoint.setScale(newScale)
                let locationAfterScale = zoomLocation
                sender.scale = 1.0
            }
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
        self.viewpoint.position = CGPoint(x: self.viewpoint.position.x + horizontalDisplacement,
            y: self.viewpoint.position.y + verticalDisplacement)
    }
}
