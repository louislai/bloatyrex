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
    private var viewpoint = SKNode()

    override init(size: CGSize) {
        super.init(size: size)
        // set up the viewpoint
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(self.content)
        self.content.name = "content"
        self.viewpoint.name = "viewpoint"
        self.content.addChild(viewpoint)
        self.content.zPosition = 0.9
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            moveViewpointToPoint(touch.locationInNode(content))
        }
    }

    override func didSimulatePhysics() {
        self.centerOnNode(self.viewpoint)
    }

    func centerOnNode(node: SKNode) {
        let cameraPositionInScene = self.convertPoint(node.position, fromNode: content)
        print(cameraPositionInScene)
        content.position = CGPoint(x: content.position.x - cameraPositionInScene.x, y: content.position.y - cameraPositionInScene.y)
    }

    /// Adds a node to be part of the content that is pannable.
    func addNodeToContent(node: SKNode) {
        content.addChild(node)
    }

    /// Moves the viewpoint over the scene to the given point.
    func moveViewpointToPoint(point: CGPoint) {
        self.viewpoint.position = point
    }
}
