//
//  ProgramSupplier.swift
//  FinalProject
//
//  Created by louis on 23/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// The ProgramSupplier protocol allows an object to invoke it to return a program tree

import Foundation

protocol ProgramSupplier: class {
    func retrieveProgram() -> Program?
}
