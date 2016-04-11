//
//  PresetMap.swift
//  FinalProject
//
//  Created by louis on 10/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

class PresetMap: Map {
    let numberOfStars: Int
    var scoresForRatings: [Int]

    init(numberOfRows: Int, numberOfColumns: Int, numberOfStars: Int) {
        self.numberOfStars = numberOfStars
        self.scoresForRatings = [Int](count: numberOfStars, repeatedValue: 0)
        super.init(numberOfRows: numberOfRows, numberOfColumns: numberOfColumns)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Assign the scores for different ratings
    ///
    /// - parameter scores: a list of scores to assigned. The list's size should be numberOfStars.
    ///     All scores should be >= 0
    func assignScoresForRatings(scores: [Int]) {
        guard scores.count == numberOfStars else {
            return
        }

        guard scores.filter({$0 >= 0}).count == scores.count else {
            return
        }

        let sortedScores = scores.sort()
        scoresForRatings = sortedScores
    }
}
