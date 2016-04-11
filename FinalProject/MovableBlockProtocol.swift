//
//  MovableBlockProtocol.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 10/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

protocol MovableBlockProtocol: class {
    var position: CGPoint { get set }

    var containingBlock: ContainerBlockProtocol { get set }

    var blockPosition: Int { get }

    var category: BlockCategory { get }

    func deactivateDropZone()

    func activateDropZone()

    func removeFromParent()
}
