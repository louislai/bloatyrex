//
//  ContainerBlockProtocol.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 4/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

protocol ContainerBlockProtocol: class {
    func insertBlock(block: CodeBlock, insertionPosition: InsertionPosition)

    func removeBlockAtIndex(index: Int)
}
