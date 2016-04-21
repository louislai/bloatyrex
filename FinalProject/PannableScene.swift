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

struct PannableSceneConstants {
    static let defaultVerticalPanBuffer: CGFloat = 260.0
    static let defaultHorizontalPanBuffer: CGFloat = 50.0
    static let zoomRangeFactor: CGFloat = 2.0
    static let doubleTapGestureTapsRequired = 2
    static let panGestureTouchesRequired = 2
    static let pinchGestureTouchesRequired = 2
    static let noDisplacement: CGFloat = 0
    static let minimumBoundary: CGFloat = 0
    static let doubleTapZoomOutScaleFactor: CGFloat = 0.5
    static let defaultGestureScale: CGFloat = 1.0
}

class PannableScene: SKScene {
    var content = SKNode()
    var overlay = SKNode()
    var verticalPanBuffer = PannableSceneConstants.defaultVerticalPanBuffer
    var horizontalPanBuffer = PannableSceneConstants.defaultHorizontalPanBuffer
    private var viewpoint: SKCameraNode = SKCameraNode()
    private var initialScale: CGFloat
    private var currentScale: CGFloat
    private var minimumScale: CGFloat
    private var maximumScale: CGFloat
    private var isPanningFromOverlay = false
    private var horizontalPanDisabled: Bool
    private var verticalPanDisabled: Bool
    private var doubleTapDisabled: Bool
    private var originalViewpointPosition = CGPoint()

    /**
    Initialise the scene with a given size, and optional scale and overlay z position.
    - parameter initialZoomLevel: how far the camera is zoomed in, e.g. 1 is no zoom,2 is 2x zoom.
    - parameter overlayZPosition: the Z position of the overlay.
    - parameter disableHorizontalPan: whether horizontal panning is disabled.
    - parameter disableVerticalPan: whether vertital panning is disabled.
    - parameter disableDoubleTap: whether the double tap recognizer to zoom is disabled.
    */
    init(size: CGSize, initialZoomLevel: CGFloat = 1, overlayZPosition: CGFloat = 10,
        disableHorizontalPan: Bool = false, disableVerticalPan: Bool = false,
        disableDoubleTap: Bool = false) {
        // scale is the inverse of zoom
        initialScale = 1.0 / initialZoomLevel
        minimumScale = initialScale / PannableSceneConstants.zoomRangeFactor
        maximumScale = initialScale * PannableSceneConstants.zoomRangeFactor
        horizontalPanDisabled = disableHorizontalPan
        verticalPanDisabled = disableVerticalPan
        doubleTapDisabled = disableDoubleTap
        currentScale = initialScale
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
        originalViewpointPosition = viewpoint.position

        // set up gestures
        let pinchRecognizer = UIPinchGestureRecognizer(target: self,
            action: #selector(PannableScene.handlePinch(_:)))
        self.view!.addGestureRecognizer(pinchRecognizer)
        let doubleTapRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(PannableScene.handleDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired =
            PannableSceneConstants.doubleTapGestureTapsRequired
        self.view!.addGestureRecognizer(doubleTapRecognizer)
        let panRecognizer = UIPanGestureRecognizer(target: self,
                                                   action: #selector(PannableScene.handlePan(_:)))
        panRecognizer.maximumNumberOfTouches = PannableSceneConstants.panGestureTouchesRequired
        panRecognizer.minimumNumberOfTouches = PannableSceneConstants.panGestureTouchesRequired
        self.view!.addGestureRecognizer(panRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Can be overriden to dynamically dispatch subclasses with the overriden method.
    func resetOtherTouches() {
    }

    /**
    Sets the scale of the viewpoint. The given scale will be adjusted if it is beyond the bounds
    of the minimum and maximum scale values.
    */
    func setViewpointScale(scale: CGFloat) {
        var boundedScale = min(scale, maximumScale)
        boundedScale = max(boundedScale, minimumScale)
        viewpoint.setScale(boundedScale)
        currentScale = boundedScale
    }

    /**
    Sets the minimum scale of the viewpoint. The minimum scale should be smaller than or equal to
    the initial and maximum scales.
    */
    func setMinimumScale(scale: CGFloat) {
        minimumScale = scale
    }

    /**
    Sets the minimum scale of the viewpoint. The minimum scale should be greater than or equal to
    the initial and minimum scales.
    */
    func setMaximumScale(scale: CGFloat) {
        maximumScale = scale
    }

    /**
    Handles the translation of the viewpoint using the pan gesture. Translation does not occur if
    the gesture starts from a node in the overlay. Horizontal/vertical translation can be disabled
    during initialization.
    */
    func handlePan(sender: UIPanGestureRecognizer) {
        resetOtherTouches()
        sender.cancelsTouchesInView = false
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
            let contentFrame = content.calculateAccumulatedFrame()
            let contentCenter = CGPoint(x: contentFrame.midX, y: contentFrame.midY)

            // calculate the horizontal and vertical amount the viewpoint should move based on
            // the pan movement and the size of the content
            if horizontalPanDisabled {
                horizontalDisplacement = PannableSceneConstants.noDisplacement
            } else if horizontalDisplacement > PannableSceneConstants.noDisplacement {
                let leftBoundaryOfContent = contentCenter.x - contentFrame.width / 2
                let viewpointDistanceToLeftBoundaryOfContent = (viewpoint.position.x -
                    leftBoundaryOfContent) / currentScale
                let viewpointDistanceToLeftBoundary = viewpoint.position.x
                var distanceToViewLeftmostContent = viewpointDistanceToLeftBoundaryOfContent -
                    viewpointDistanceToLeftBoundary
                distanceToViewLeftmostContent = max(distanceToViewLeftmostContent,
                    PannableSceneConstants.noDisplacement)

                // leftmost position of viewpoint allowed so as to not pan out of visible content
                var minimumAllowedHorizontalViewpointPosition = originalViewpointPosition.x -
                    distanceToViewLeftmostContent
                if distanceToViewLeftmostContent > PannableSceneConstants.noDisplacement {
                    minimumAllowedHorizontalViewpointPosition -= horizontalPanBuffer
                }
                let minimumAllowedHorizontalDisplacement =
                    minimumAllowedHorizontalViewpointPosition - viewpoint.position.x
                horizontalDisplacement = min(-minimumAllowedHorizontalDisplacement,
                    horizontalDisplacement)
            } else if horizontalDisplacement < PannableSceneConstants.noDisplacement {
                let rightBoundaryOfContent = contentCenter.x + contentFrame.width / 2
                let viewpointDistanceToRightBoundaryOfContent = (rightBoundaryOfContent -
                    viewpoint.position.x) / currentScale
                let viewpointDistanceToRightBoundary = self.size.width - viewpoint.position.x
                var distanceToViewRightmostContent = viewpointDistanceToRightBoundaryOfContent -
                viewpointDistanceToRightBoundary
                distanceToViewRightmostContent = max(distanceToViewRightmostContent,
                    PannableSceneConstants.noDisplacement)

                // rightmost position of viewpoint allowed so as to not pan out of visible content
                var maximumAllowedHorizontalViewpointPosition = originalViewpointPosition.x +
                distanceToViewRightmostContent
                if distanceToViewRightmostContent > PannableSceneConstants.noDisplacement {
                    maximumAllowedHorizontalViewpointPosition += horizontalPanBuffer
                }
                var maximumAllowedHorizontalViewpointDisplacement =
                    maximumAllowedHorizontalViewpointPosition - viewpoint.position.x
                maximumAllowedHorizontalViewpointDisplacement =
                    max(maximumAllowedHorizontalViewpointDisplacement,
                        PannableSceneConstants.noDisplacement)
                horizontalDisplacement = max(-maximumAllowedHorizontalViewpointDisplacement,
                                             horizontalDisplacement)
            }
            if verticalPanDisabled {
                verticalDisplacement = PannableSceneConstants.noDisplacement
            } else if verticalDisplacement > PannableSceneConstants.noDisplacement {
                let bottomBoundaryOfContent = contentCenter.y - contentFrame.height / 2

                // bottommost position of viewpoint allowed so as to not pan out of visible content
                let minimumAllowedVerticalViewpointPosition = bottomBoundaryOfContent -
                    verticalPanBuffer * currentScale
                let minimumAllowedVerticalViewpointDisplacement =
                    minimumAllowedVerticalViewpointPosition - viewpoint.position.y

                verticalDisplacement = min(-minimumAllowedVerticalViewpointDisplacement,
                                           verticalDisplacement)
            } else if verticalDisplacement < PannableSceneConstants.noDisplacement {
                let topBoundaryOfContent = contentCenter.y + contentFrame.height / 2

                // topmost position of viewpoint allowed so as to not pan out of visible content
                let maximumAllowedVerticalViewpointPosition = topBoundaryOfContent +
                    verticalPanBuffer * currentScale

                var maximumAllowedVerticalViewpointDisplacement =
                    maximumAllowedVerticalViewpointPosition - viewpoint.position.y
                maximumAllowedVerticalViewpointDisplacement =
                    max(maximumAllowedVerticalViewpointDisplacement,
                        PannableSceneConstants.noDisplacement)
                verticalDisplacement = max(-maximumAllowedVerticalViewpointDisplacement,
                                           verticalDisplacement)
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
        resetOtherTouches()
        sender.cancelsTouchesInView = false
        if sender.numberOfTouches() == PannableSceneConstants.pinchGestureTouchesRequired {
            if sender.state == .Changed {
                // The scale applied to the contents is the inverse of the camera node’s scale
                var newScale = viewpoint.xScale * (1.0 / sender.scale)
                if newScale < minimumScale {
                    newScale = minimumScale
                } else if newScale > maximumScale {
                    newScale = maximumScale
                }
                currentScale = newScale
                viewpoint.setScale(newScale)
                sender.scale = PannableSceneConstants.defaultGestureScale
            }
        }
    }

    /**
    Handles zooming in on the desired location using a double tap. Does not zoom or pan to tapped
    location if the tapped location is on a node in the overlay.
    */
    func handleDoubleTap(sender: UITapGestureRecognizer) {
        resetOtherTouches()
        if !doubleTapDisabled {
            let tapLocation = sender.locationInView(sender.view)
            let zoomLocation = self.convertPointFromView(tapLocation)
            let touchedNode = self.nodeAtPoint(zoomLocation)
            if !isPartOfOverlay(touchedNode) {
                // zoom in on tapped location
                var horizontalZoomLocation = zoomLocation.x
                var verticalZoomLocation = zoomLocation.y
                // restrict the tap location to within the scene
                if horizontalZoomLocation < PannableSceneConstants.minimumBoundary {
                    horizontalZoomLocation = max(horizontalZoomLocation, -self.size.width / 2)
                } else {
                    horizontalZoomLocation = min(horizontalZoomLocation, self.size.width / 2)
                }
                if verticalZoomLocation < PannableSceneConstants.minimumBoundary {
                    verticalZoomLocation = max(verticalZoomLocation, -self.size.height / 2)
                } else {
                    verticalZoomLocation = min(verticalZoomLocation, self.size.height / 2)
                }
                let boundedZoomLocation = CGPoint(x: horizontalZoomLocation,
                                                  y: verticalZoomLocation)
                viewpoint.position = boundedZoomLocation
                var newScale = viewpoint.xScale * PannableSceneConstants.doubleTapZoomOutScaleFactor

                // restrict the maximum zoom
                newScale = max(newScale, minimumScale)

                // zoom out if already at maximum zoom
                if viewpoint.xScale == minimumScale {
                    newScale = initialScale
                }
                currentScale = newScale
                viewpoint.setScale(newScale)
            }
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

    /**
        Returns the current scale of the viewpoint.
    */
    func getScale() -> CGFloat {
        return currentScale
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
