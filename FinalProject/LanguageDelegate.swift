//
//  LanguageDelegate.swift
//  FinalProject
//
//  Created by louis on 12/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

protocol LanguageDelegate {
    func nextAction(agent: Agent) -> Action
}