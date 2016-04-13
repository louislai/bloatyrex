//
//  PresetMap.swift
//  FinalProject
//
//  Created by louis on 10/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

class PresetMap: Map {
    private let numberOfStars: Int
    // Invariant: This is sorted in ascending order
    private var scoresForRatings: [Int]

    init(numberOfRows: Int, numberOfColumns: Int, numberOfStars: Int) {
        self.numberOfStars = numberOfStars
        self.scoresForRatings = [Int](count: numberOfStars+1, repeatedValue: 0)
        super.init(numberOfRows: numberOfRows, numberOfColumns: numberOfColumns)
    }

    required init?(coder aDecoder: NSCoder) {
        self.numberOfStars = aDecoder.decodeIntegerForKey("numberOfStars")
        self.scoresForRatings = aDecoder.decodeObjectForKey("scoresForRatings") as! [Int]
        super.init(coder: aDecoder)
    }

    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(numberOfStars, forKey: "numberOfStars")
        aCoder.encodeObject(scoresForRatings, forKey: "scoresForRatings")
        super.encodeWithCoder(aCoder)
    }

    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = PresetMap(numberOfRows: numberOfRows, numberOfColumns: numberOfColumns, numberOfStars: numberOfStars)
        for row in 0..<numberOfRows {
            for column in 0..<numberOfColumns {
                copy.grid[row][column] = grid[row][column].copy() as! MapUnitNode
            }
        }
        copy.scoresForRatings = scoresForRatings
        return copy
    }

    /// Assign the scores for different ratings
    ///
    /// - parameter scores: a list of scores to assigned. The list's size should be numberOfStars.
    ///     All scores should be >= 0
    ///
    /// This also auto add a 0 to the front of the list to represent 0 rating
    func assignScoresForRatings(scores: [Int]) {
        guard scores.count == numberOfStars else {
            return
        }

        guard scores.filter({$0 >= 0}).count == scores.count else {
            return
        }
        var sortedScores = scores.sort()
        sortedScores.insert(0, atIndex: 0)
        scoresForRatings = sortedScores
    }

    /// Return rating if score is valid (>= 0) else return -1
    func getRatingForScore(score: Int) -> Int {
        guard score >= 0 else {
            return -1
        }
        var currentRating = numberOfStars
        while scoresForRatings[currentRating] > score {
            currentRating -= 1
        }
        return currentRating
    }
}
