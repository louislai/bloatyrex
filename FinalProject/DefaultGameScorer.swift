//
//  DefaultGameScorer.swift
//  FinalProject
//
//  Created by louis on 13/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// DefaultGameScorer implement the Scorer protocol
/// It calculates the scores naively by summing all the raw values of the score criteria

import Foundation

class DefaultGameScorer: Scorer {
    func criteriaToScore(criteria: [ScoreCriterion]) -> Int {
        return criteria.reduce(0) { $0 + $1.getValue() }
    }
}
