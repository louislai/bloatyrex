//
//  ProgramSupplier.swift
//  FinalProject
//
//  Created by louis on 23/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

protocol ProgramSupplier {
    func retrieveProgram() -> Program
}

struct sample: ProgramSupplier {
    func retrieveProgram() -> Program {
        return Sample.sampleProgram
    }
}