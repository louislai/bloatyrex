//
//  ScoreCriterion.swift
//  FinalProject
//
//  Created by louis on 13/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

protocol ScoreCriterion {
    var value: Int { get }
    var type: ScoreCriterionType { get }
}

enum ScoreCriterionType: Int {
    case MovesLeft
    case ProgramLength
}
