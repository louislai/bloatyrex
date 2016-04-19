//
//  ScoreCriterion.swift
//  FinalProject
//
//  Created by louis on 13/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// A list of score criterion that can be used to be converted to score

import Foundation

enum ScoreCriterion {
    case MovesLeft(Int)
    case ProgramLength(Int)

    func getValue() -> Int {
        switch self {
        case .MovesLeft(let value):
            return value
        case .ProgramLength(let value):
            return value
        }
    }
}
