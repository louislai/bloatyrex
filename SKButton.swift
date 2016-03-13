//
//  SKButton.swift
//  FinalProject
//
//  Created by louis on 13/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class SKButton: SKNode {
    var defaultButton: SKNode
    var activeButton: SKNode?
    var action: (() -> Void)?

    init(defaultButton: SKNode, activeButton: SKNode? = nil) {
            self.defaultButton = defaultButton
            super.init()
            addChild(defaultButton)
            if let button = activeButton {
                self.activeButton = button
                addChild(button)
            }
            activeButton?.hidden = true
            userInteractionEnabled = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(touches: Set<UITouch>,
        withEvent event: UIEvent?) {
            if activeButton != nil {
                activeButton?.hidden = false
                defaultButton.hidden = true
            }
    }

    override func touchesMoved(touches: Set<UITouch>,
        withEvent event: UIEvent?) {
            let touch: UITouch = touches.first! as UITouch
            let location: CGPoint = touch.locationInNode(self)

            // Only need this if we have an active button child node
            if activeButton != nil {
                if defaultButton.containsPoint(location) {
                    activeButton?.hidden = false
                    defaultButton.hidden = true
                } else {
                    activeButton?.hidden = true
                    defaultButton.hidden = false
                }
            }
    }

    override func touchesEnded(touches: Set<UITouch>,
        withEvent event: UIEvent?) {
            let touch: UITouch = touches.first! as UITouch
            let location: CGPoint = touch.locationInNode(self)

            if defaultButton.containsPoint(location) {
                if let action = action {
                    action()
                }
            }

            activeButton?.hidden = true
            defaultButton.hidden = false
    }
}
