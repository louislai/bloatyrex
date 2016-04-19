//
//  AgentProtocol.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 13/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// AgentProtocol to be used by the interpreter

import Foundation

protocol AgentProtocol {
    var xPosition: Int { get }
    var yPosition: Int { get }
    var direction: Direction { get }
    func isNextStepSafe() -> Bool
}
