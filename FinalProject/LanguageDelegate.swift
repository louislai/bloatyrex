//
//  LanguageDelegate.swift
//  FinalProject
//
//  Created by louis on 12/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// LanguageDelegate protocol enforces method nextAction to be used by AgentNode
/// to retrieve the next action to be executed

import Foundation

protocol LanguageDelegate {
    /// Returns the next action
    /// Returns nil if program terminates
    func nextAction(map: Map, agent: AgentProtocol) -> Action?
}
