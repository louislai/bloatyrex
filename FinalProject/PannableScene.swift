//
//  PannableScene.swift
//  FinalProject
//
//  Created by Tham Zheng Yi on 17/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
//

import Foundation
import SpriteKit

///  This scene can be subclassed instead of subclassing SKScene to have a pannable scene. Add the
///  nodes that are intended to be pannable to the content and add nodes that should be fixed in
///  position regardless of panning to the overlay.
///
///  The node hierarchy is as follows:
///
///          PannableScene
///
///          /           \
///
///      content       viewpoint
///
///                       |
///
///                    overlay
///
///  It is important to account for the fact that the nodes added will be added to either the
///  content or the overlay and hence no longer be direct descendants of the PannableScene itself.
///  For example, locationOfNode could have to be taken with respect to the content or
///  the overlay node instead of self.
///
///  PannableScene uses pan, double tap and pinch gesture recognizers for its translation and
///  zooming functionality and hence may not work correctly if more of such recognizers are added.
///  The pan gesture recognizer uses two touches to function and so should not interfere with
///  functions such as touchesMoved if they only require one touch.
///
///  Since PannableScene overrides didMoveToView, subclasses of PannableScene should call the super
///  didMoveToView method in order to get PannableScenes functionality.
///
class PannableScene: SKScene {
    var content = SKNode()
    var overlay = SKNode()
    private var viewpoint: SKCameraNode = SKCameraNode()
    private var initialScale: CGFloat
    private var minimumScale: CGFloat
    private var isPanningFromOverlay = false
    private var horizontalPanDisabled: Bool
    private var verticalPanDisabled: Bool

    /**
    Initialise the scene with a given size, and optional scale and overlay z position.

    - parameter zoomLevel: is how far the camera is zoomed in, e.g. 1 is no zoom and 2 is 2x zoom.

    - parameter zoomRangeFactor: denotes how much the zoom level can be adjusted. The default value of 2.0
    allows the zoom to be a max 2.0 times larger than the original zoom level.
    */
    init(size: CGSize, zoomLevel: CGFloat = 1, overlayZPosition: CGFloat = 10,
         zoomRangeFactor: CGFloat = 2.0, enableDoubleTap: Bool = true,
         disableHorizontalPan: Bool = false, disableVerticalPan: Bool = false) {
        initialScale = 1.0 / zoomLevel
        minimumScale = initialScale / zoomRangeFactor
        horizontalPanDisabled = disableHorizontalPan
        verticalPanDisabled = disableVerticalPan
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

        // set up gestures
        let pinchRecognizer = UIPinchGestureRecognizer(target: self,
            action: #selector(PannableScene.handlePinch(_:)))
        self.view!.addGestureRecognizer(pinchRecognizer)
        let doubleTapRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(PannableScene.handleDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        self.view!.addGestureRecognizer(doubleTapRecognizer)
        let panRecognizer = UIPanGestureRecognizer(target: self,
                                                   action: #selector(PannableScene.handlePan(_:)))
        panRecognizer.maximumNumberOfTouches = 2
        panRecognizer.minimumNumberOfTouches = 2
        self.view!.addGestureRecognizer(panRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
    Handles the translation of the viewpoint using the pan gesture. Translation does not occur if
    the gesture starts from a node in the overlay. Horizontal/vertical translation can be disabled
    during initialization.
    */
    func handlePan(sender: UIPanGestureRecognizer) {
        if sender.state == .Began {
            var touchLocation = sender.locationInView(sender.view!)
            touchLocation = self.convertPointFromView(touchLocation)
            let touchedNode = self.nodeAtPoint(touchLocation)
            if isPartOfOverlay(touchedNode) {
                isPanningFromOverlay = true
            }
        } else if sender.state == .Changed && isPanningFromOverlay == false {
            var translation = sender.translationInView(sender.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            var horizontalDisplacement = translation.x
            var verticalDisplacement = translation.y

            if horizontalPanDisabled {
                horizontalDisplacement = 0
            } else if horizontalDisplacement > 0 {
                let distanceToLeftBoundary = self.size.width / 2 + viewpoint.position.x
                horizontalDisplacement = min(distanceToLeftBoundary, horizontalDisplacement)
            } else if horizontalDisplacement < 0 {
                let distanceToRightBoundary = self.size.width / 2 - viewpoint.position.x
                horizontalDisplacement = -min(distanceToRightBoundary, -horizontalDisplacement)
            }
            if verticalPanDisabled {
                verticalDisplacement = 0
            } else if verticalDisplacement > 0 {
                var distanceToBottomBoundary = self.size.height / 2 + viewpoint.position.y
                distanceToBottomBoundary = max(distanceToBottomBoundary, 0)
                verticalDisplacement = min(distanceToBottomBoundary, verticalDisplacement)
            } else if verticalDisplacement < 0 {
                let distanceToTopBoundary = self.size.height / 2 - viewpoint.position.y
                verticalDisplacement = -min(distanceToTopBoundary, -verticalDisplacement)
            }

            // viewpoint moves in opposite direction from pan to simulate movement
            moveViewPointBy(-horizontalDisplacement,
                            verticalDisplacement: -verticalDisplacement)

            sender.setTranslation(CGPoint.zero, inView: sender.view)
        } else if sender.state == .Ended {
            isPanningFromOverlay = false
        }
    }

    /**
    Handles the zooming in and out using the pinch gesture.
    */
    func handlePinch(sender: UIPinchGestureRecognizer) {
        if sender.numberOfTouches() == 2 {
            if sender.state == .Changed {
                // The scale applied to the contents is the inverse of the camera node’s scale
                var newScale = viewpoint.xScale * (1.0 / sender.scale)
                if newScale < minimumScale {
                    newScale = minimumScale
                } else if newScale > initialScale {
                    newScale = initialScale
                }
                viewpoint.setScale(newScale)
                sender.scale = 1.0
            }
        }
    }

    /**
    Handles zooming in on the desired location using a double tap. Does not zoom or pan to tapped
    location if the tapped location is on a node in the overlay.
    */
    func handleDoubleTap(sender: UITapGestureRecognizer) {
        let tapLocation = sender.locationInView(sender.view)
        let zoomLocation = self.convertPointFromView(tapLocation)
        let touchedNode = self.nodeAtPoint(zoomLocation)
        if !isPartOfOverlay(touchedNode) {
             // zoom in on tapped location
            var horizontalZoomLocation = zoomLocation.x
            var verticalZoomLocation = zoomLocation.y
            // restrict the tap location to within the scene
            if horizontalZoomLocation < 0 {
                horizontalZoomLocation = max(horizontalZoomLocation, -self.size.width / 2)
            } else {
                horizontalZoomLocation = min(horizontalZoomLocation, self.size.width / 2)
            }
            if verticalZoomLocation < 0 {
                verticalZoomLocation = max(verticalZoomLocation, -self.size.height / 2)
            } else {
                verticalZoomLocation = min(verticalZoomLocation, self.size.height / 2)
            }
            let boundedZoomLocation = CGPoint(x: horizontalZoomLocation, y: verticalZoomLocation)
            viewpoint.position = boundedZoomLocation
            var newScale = viewpoint.xScale * 0.5

            // restrict the maximum zoom
            newScale = max(newScale, minimumScale)
            viewpoint.setScale(newScale)
        }
    }

    /**
    Adds a node to be part of the content that is pannable. Added nodes will be children of the
    content node, which is itself a child of the pannable scene (self).
    */
    func addNodeToContent(node: SKNode) {
        content.addChild(node)
    }

    /**
        Adds a node to the overlay. Added nodes will be children of the overlay node. The hierarchy
        is as follows: pannable scene (self) -> viewpoint node -> overlay node -> added node.
    */
    func addNodeToOverlay(node: SKNode) {
        overlay.addChild(node)
    }

    // Moves the viewpoint by a given X and Y value.
    private func moveViewPointBy(horizontalDisplacement: CGFloat, verticalDisplacement: CGFloat) {
        self.viewpoint.position = CGPoint(x: self.viewpoint.position.x + horizontalDisplacement,
            y: self.viewpoint.position.y + verticalDisplacement)
    }

    // Checks whether the given node is part of the overlay.
    private func isPartOfOverlay(node: SKNode) -> Bool {
         return node.inParentHierarchy(overlay)
    }
}
