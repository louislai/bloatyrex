//
//  ScoreConverter.swift
//  FinalProject
//
//  Created by louis on 13/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// Scorer protocol converts a list of criteria into an actual score.

import Foundation

protocol Scorer {
    func criteriaToScore(criteria: [ScoreCriterion]) -> Int
}
