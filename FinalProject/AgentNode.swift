//
//  Agent.swift
//  FinalProject
//
//  Created by louis on 12/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class AgentNode: SKSpriteNode {
    var orientation = Direction.Up
    var map: Map!
    var row: Int!
    var column: Int!
    var delegate: LanguageDelegate!

    func setOrientationTo(direction: Direction) {
        orientation = direction
    }

    func moveForward() {
        if let (nextRow, nextColumn) = nextPosition() {
            row = nextRow
            column = nextColumn
        }
    }

    private func nextPosition() -> (row: Int, column: Int)? {
        var nextRow: Int = row
        var nextColumn: Int = column
        switch orientation {
        case .Up:
            guard row < map.numberOfRows-1 else {
                return nil
            }
            nextRow += 1
        case .Right:
            guard column < map.numberOfColumns-1 else {
                return nil
            }
            nextColumn += 1
        case .Down:
            guard row > 0 else {
                return nil
            }
            nextRow -= 1
        case .Left:
            guard column > 0 else {
                return nil
            }
            nextColumn -= 1

        }
        let nextUnit = map.retrieveMapUnitAt(nextRow, column: nextColumn)
        guard nextUnit != .Agent && nextUnit != .Wall else {
            return nil
        }
        return (row: nextRow, column: nextColumn)
    }
}
