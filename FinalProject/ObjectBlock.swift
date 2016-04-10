//
//  ObjectBlock.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 6/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class ObjectBlock: SKNode, MovableBlockProtocol {
    private var containingBlockValue: ContainerBlockProtocol
    var blockPosition = 0
    
    var containingBlock: ContainerBlockProtocol {
        get {
            return containingBlockValue
        }
        
        set(newBlock) {
            containingBlockValue = newBlock
        }
    }
    
    func getMapUnit() -> MapUnitType {
        return MapUnitType.EmptySpace
    }
    
    init(containingBlock: ContainerBlockProtocol) {
        self.containingBlockValue = containingBlock
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
