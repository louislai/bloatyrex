//
//  BoolOpBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 5/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class BoolOpBlock: SKNode, MovableBlockProtocol {

    private var containingBlockValue: ContainerBlockProtocol
    var blockPosition = 0
    var containingZone: DropZone
    let category = BlockCategory.BoolOp

    var containingBlock: ContainerBlockProtocol {
        get {
            return containingBlockValue
        }

        set(newBlock) {
            containingBlockValue = newBlock
        }
    }

    var objectZones: [DropZone] {
        return []
    }

    func activateDropZone() {
        return
    }

    func deactivateDropZone() {
        return
    }

    func insertBlock(block: ObjectBlock) {
        return
    }

    func getBlockPredicate() -> Predicate? {
        return nil
    }

    func getBlock(location: CGPoint) -> MovableBlockProtocol? {
        return self
    }

    init(containingBlock: ContainerBlockProtocol, containingZone: DropZone) {
        self.containingBlockValue = containingBlock
        self.containingZone = containingZone
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
