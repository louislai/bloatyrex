//
//  FinishedEditingProgramDelegate.swift
//  FinalProject
//
//  Created by Tham Zheng Yi on 11/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// This FinishedEdittingProgramDelegate shoud be applied on a ProgrammingViewController instance
/// Used to dismiss a ProgrammingViewController instance

import Foundation

protocol FinishedEditingProgramDelegate: class {
    /// Handles when the user has finished editing the program
    func finishedEditing(controller: ProgrammingViewController)
}
