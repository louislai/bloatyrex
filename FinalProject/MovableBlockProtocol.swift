//
//  MovableBlockProtocol.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 10/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

/// Protocol for blocks that are meant to be moved around in the programming view.
/// These required methods help to position, categorize, and control the behaviour of the blocks
/// correctly
protocol MovableBlockProtocol: class {
    var position: CGPoint { get set }

    var containingBlock: ContainerBlockProtocol { get set }

    var blockPosition: Int { get }

    var category: BlockCategory { get }

    /**
     Deactivates the drop zones for the block. This is especially important when moving blocks, such
     that the block does not snap to itself
     **/
    func deactivateDropZone()

    /**
     Activateds the drop zone to allow other blocks to snap to it.
     **/
    func activateDropZone()

    func removeFromParent()
}
