//
//  ObjectBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 6/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

/// This class represents objects that can appear on the map and be observed by the agent. As the
/// properties of these blocks are largely the same save a few fields and images, objects of this
/// class is only instantiated by static factory methods.

class ObjectBlock: SKNode, MovableBlockProtocol {
    private var containingBlockValue: ContainerBlockProtocol
    var blockPosition = 0
    var containingZone: DropZone
    let category = BlockCategory.Object
    let objectType: MapUnitType

    /**
     Retrieves the container block that holds this object block
     **/
    var containingBlock: ContainerBlockProtocol {
        get {
            return containingBlockValue
        }

        set(newBlock) {
            containingBlockValue = newBlock
        }
    }

    static func getHoleBlock(containingBlock containingBlock: ContainerBlockProtocol, containingZone: DropZone) -> ObjectBlock {
        let block = ObjectBlock(containingBlock: containingBlock, containingZone: containingZone, objectType: MapUnitType.Hole)
        block.setSprite(GlobalConstants.ImageNames.hole)
        return block
    }

    static func getWoodBlock(containingBlock containingBlock: ContainerBlockProtocol, containingZone: DropZone) -> ObjectBlock {
        let block = ObjectBlock(containingBlock: containingBlock, containingZone: containingZone, objectType: MapUnitType.WoodenBlock)
        block.setSprite(GlobalConstants.ImageNames.wooden_block)
        return block
    }

    static func getWallBlock(containingBlock containingBlock: ContainerBlockProtocol, containingZone: DropZone) -> ObjectBlock {
        let block = ObjectBlock(containingBlock: containingBlock, containingZone: containingZone, objectType: MapUnitType.Wall)
        block.setSprite(GlobalConstants.ImageNames.wall)
        return block
    }

    static func getEmptySpaceBlock(containingBlock containingBlock: ContainerBlockProtocol, containingZone: DropZone) -> ObjectBlock {
        let block = ObjectBlock(containingBlock: containingBlock, containingZone: containingZone, objectType: MapUnitType.EmptySpace)
        block.setSprite(GlobalConstants.ImageNames.space)
        return block
    }

    static func getMonsterBlock(containingBlock containingBlock: ContainerBlockProtocol, containingZone: DropZone) -> ObjectBlock {
        let block = ObjectBlock(containingBlock: containingBlock, containingZone: containingZone, objectType: MapUnitType.Monster)
        block.setSprite(GlobalConstants.ImageNames.monster_static)
        return block
    }

    static func getToiletBlock(containingBlock containingBlock: ContainerBlockProtocol, containingZone: DropZone) -> ObjectBlock {
        let block = ObjectBlock(containingBlock: containingBlock, containingZone: containingZone, objectType: MapUnitType.Goal)
        block.setSprite(GlobalConstants.ImageNames.goal)
        return block
    }

    static func getLeftDoorBlock(containingBlock containingBlock: ContainerBlockProtocol, containingZone: DropZone) -> ObjectBlock {
        let block = ObjectBlock(containingBlock: containingBlock, containingZone: containingZone, objectType: MapUnitType.DoorLeft)
        block.setSprite(GlobalConstants.ImageNames.buttons_left)
        return block
    }

    static func getRightDoorBlock(containingBlock containingBlock: ContainerBlockProtocol, containingZone: DropZone) -> ObjectBlock {
        let block = ObjectBlock(containingBlock: containingBlock, containingZone: containingZone, objectType: MapUnitType.DoorRight)
        block.setSprite(GlobalConstants.ImageNames.buttons_right)
        return block
    }

    private func setSprite(imageNamed: String) {
        let blockBody = SKSpriteNode(imageNamed: imageNamed)
        let size = GlobalConstants.CodeBlocks.blockSize
        blockBody.size = CGSize(width: size, height: size)
        blockBody.position = CGPoint(x: blockBody.size.height / 2, y: blockBody.size.width / 2)
        addChild(blockBody)
    }

    /**
     Returns the map unit this block is associated to
     **/
    func getMapUnit() -> MapUnitType {
        return objectType
    }

    private init(containingBlock: ContainerBlockProtocol, containingZone: DropZone, objectType: MapUnitType) {
        self.containingZone = containingZone
        self.containingBlockValue = containingBlock
        self.objectType = objectType
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func deactivateDropZone() {
        return
    }

    func activateDropZone() {
        return
    }
}
