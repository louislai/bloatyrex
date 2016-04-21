//
//  GameRatingsTests.swift
//  FinalProject
//
//  Created by louis on 13/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import XCTest

class GameRatingsTests: XCTestCase {
    var map: PresetMap!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.map = PresetMap(numberOfRows: 4, numberOfColumns: 4, numberOfStars: 3)
    }

    func testInitialPresetMap() {
        XCTAssertEqual(map.getRatingForScore(0), 3)
        XCTAssertEqual(map.getRatingForScore(-1), -1)
    }

    func testAssignScoresPresetMap() {
        map.assignScoresForRatings([1, 1, 1, 1])
        XCTAssertEqual(map.getRatingForScore(0), 3)

        map.assignScoresForRatings([2, 1, 4])
        XCTAssertEqual(map.getRatingForScore(0), 0)
        XCTAssertEqual(map.getRatingForScore(1), 1)
        XCTAssertEqual(map.getRatingForScore(2), 2)
        XCTAssertEqual(map.getRatingForScore(3), 2)
        XCTAssertEqual(map.getRatingForScore(4), 3)
    }

    func testScoreCriterionReturnsCorrectValue() {
        let moves = ScoreCriterion.MovesLeft(13)
        XCTAssertEqual(moves.getValue(), 13)
        let length = ScoreCriterion.ProgramLength(12)
        XCTAssertEqual(length.getValue(), 12)
    }

    func testDefaultGameScorer() {
        let scorer = DefaultGameScorer()
        XCTAssertEqual(scorer.criteriaToScore([ScoreCriterion.MovesLeft(12)]), 12)
    }
}
