//
//  InsertionPosition.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 16/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

/// This class is passed around to dropZones to record which zones are being selected when dragging
/// blocks around for insertion
class InsertionPosition {
    var trash = false
    var position: Int?
    var container: ContainerBlockProtocol?
    var zone: DropZone?
    var category: BlockCategory?
}
