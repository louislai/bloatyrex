//
//  ActionBlock.swift
//  BloatyRex
//
//  Created by Koh Wai Kit on 20/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

/// This class represents actions that can be taken by the agent. As the
/// properties of these blocks are largely the same save a few fields and images, objects of this
/// class is only instantiated by static factory methods.

class ActionBlock: CodeBlock, HighlightableBlockProtocol {
    var highlightLayer: SKShapeNode?
    let action: Action

    static func getForwardBlock(containingBlock containingBlock: ContainerBlockProtocol) -> ActionBlock {
        let block = ActionBlock(containingBlock: containingBlock, action: Action.Forward(nil))
        block.setSprite("up-block")
        return block
    }

    static func getWaitBlock(containingBlock containingBlock: ContainerBlockProtocol) -> ActionBlock {
        let block = ActionBlock(containingBlock: containingBlock, action: Action.NoAction(nil))
        block.setSprite("wait-block")
        return block
    }

    static func getJumpBlock(containingBlock containingBlock: ContainerBlockProtocol) -> ActionBlock {
        let block = ActionBlock(containingBlock: containingBlock, action: Action.Jump(nil))
        block.setSprite("jump-block")
        return block
    }

    static func getPressBlueBlock(containingBlock containingBlock: ContainerBlockProtocol) -> ActionBlock {
        let block = ActionBlock(containingBlock: containingBlock, action: Action.ChooseButton(1, nil))
        block.setSprite("press-blue-block")
        return block
    }

    static func getPressRedBlock(containingBlock containingBlock: ContainerBlockProtocol) -> ActionBlock {
        let block = ActionBlock(containingBlock: containingBlock, action: Action.ChooseButton(0, nil))
        block.setSprite("press-red-block")
        return block
    }

    static func getTurnLeftBlock(containingBlock containingBlock: ContainerBlockProtocol) -> ActionBlock {
        let block = ActionBlock(containingBlock: containingBlock, action: Action.RotateLeft(nil))
        block.setSprite("turn-left-block")
        return block
    }

    static func getTurnRightBlock(containingBlock containingBlock: ContainerBlockProtocol) -> ActionBlock {
        let block = ActionBlock(containingBlock: containingBlock, action: Action.RotateRight(nil))
        block.setSprite("turn-right-block")
        return block
    }

    /**
     Highlights the block with a translucent overlay. Used for code tracing during its execution
     **/
    func highlight() {
        unhighlight()
        let size = GlobalConstants.CodeBlocks.blockSize
        let newLayer = SKShapeNode(rect: CGRect(x: 0, y: CodeBlock.dropZoneSize, width: size, height: size),
                                   cornerRadius: 0)
        newLayer.fillColor = UIColor.yellowColor()
        newLayer.alpha = 0.3
        newLayer.zPosition = 3
        self.addChild(newLayer)
        highlightLayer = newLayer
    }

    func unhighlight() {
        if let layer = highlightLayer {
            highlightLayer = nil
            layer.removeFromParent()
        }
    }

    private func setSprite(imageNamed: String) {
        let blockBody = SKSpriteNode(imageNamed: imageNamed)
        let size = GlobalConstants.CodeBlocks.blockSize
        blockBody.size = CGSize(width: size, height: size)
        blockBody.position = CGPoint(x: blockBody.size.width / 2,
                                     y: blockBody.size.height / 2 + CodeBlock.dropZoneSize)
        self.addChild(blockBody)
        self.resizeDropZone()
    }

    private init(containingBlock: ContainerBlockProtocol, action: Action) {
        self.action = action
        super.init(containingBlock: containingBlock)
    }

    override func getBlockConstruct() -> Construct {
        let blockAction: Action
        switch action {
        case .ChooseButton(let choice, _):
            blockAction = .ChooseButton(choice, self)
        case .Forward(_):
            blockAction = .Forward(self)
        case .Jump(_):
            blockAction = .Jump(self)
        case .NoAction(_):
            blockAction = .NoAction(self)
        case .RotateLeft(_):
            blockAction = .RotateLeft(self)
        case .RotateRight(_):
            blockAction = .RotateRight(self)
        }
        return Construct.ActionConstruct(blockAction)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
