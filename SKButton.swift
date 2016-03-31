//
//  SKButton.swift
//  FinalProject
//
//  Created by louis on 13/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

/** SKButton can be used to simulate the behaviour of UIKit UIButton on a SKNode */
class SKButton: SKNode {
    private var defaultButton: SKNode
    private var activeButton: SKNode?
    private var targetObject: NSObject?
    private var targetSelector: Selector?

    /**
     Initialize a new SKButton

     - parameter defaultButton: The required default label for the button. If activeButton is set, defaultButton will hide when button is active
     - parameter activeButton: The optional active label. This will appear when button is active if set
    */
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

    func setDefaultButton(button: SKNode) {
        defaultButton.removeFromParent()
        defaultButton = button
        addChild(defaultButton)
    }

    func setActiveButton(button: SKNode) {
        if let existingButton = activeButton {
            existingButton.removeFromParent()
        }
        activeButton = button
        addChild(button)
    }

    /**
    Add handler for when the button is tapped

    - parameter target: The object with the selector method

    - parameter selector: The selector method
    */
    func addTarget(target: NSObject, selector: Selector) {
        targetObject = target
        targetSelector = selector
    }

    /**
        Remove handler for the button
    */
    func removeTarget() {
        targetObject = nil
        targetSelector = nil
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
                if let object = targetObject,
                    selector = targetSelector where object.respondsToSelector(selector) {
                        object.performSelector(selector, withObject: touches, withObject: event)
                    }
            }

            activeButton?.hidden = true
            defaultButton.hidden = false
    }
}
