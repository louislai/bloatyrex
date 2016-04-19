//
//  ProgramBlocksSupplier.swift
//  FinalProject
//
//  Created by Tham Zheng Yi on 11/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// ProgramBlocksSupplier protocol allows the object invoking to retrieve program blocks

import Foundation

protocol ProgramBlocksSupplier: class {
    func retrieveProgramBlocks() -> ProgramBlocks
}
