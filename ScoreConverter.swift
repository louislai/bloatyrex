//
//  ScoreConverter.swift
//  FinalProject
//
//  Created by louis on 13/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

protocol ScoreConverter {
    func criteriaToScore(criteria: [ScoreCriterion]) -> Int
}

// Default implementation
extension ScoreConverter {
    func criteriaToScore(criteria: [ScoreCriterion]) -> Int {
        return criteria.reduce(0) { $0 + $1.value }
    }
}
