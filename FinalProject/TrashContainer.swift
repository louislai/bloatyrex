//
//  TrashContainer.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 4/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

/// This class is used as a container that disposes of blocks placed in it. Since the blocks are
/// always removed from their previous locations before reinsertion, by doing nothing when we
/// insert blocks here we are removing them from our program.
class TrashContainer: ContainerBlockProtocol {
    func insertBlock(block: CodeBlock, insertionPosition: InsertionPosition) {
        return
    }

    func removeBlockAtIndex(index: Int) {
        return
    }
}
