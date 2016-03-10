//
//  Map.swift
//  FinalProject
//
//  Created by louis on 10/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

class Map {
    private var grid: [[MapUnit]]
    let numberOfRows: Int
    let numberOfColumns: Int

    init(numberOfRows: Int, numberOfColumns: Int) {
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
        self.grid = [[MapUnit]](
            count: numberOfRows,
            repeatedValue: [MapUnit](
                count: numberOfColumns,
                repeatedValue: MapUnit.EmptySpace
            )
        )
    }

    func setMapUnitAt(unit: MapUnit, row: Int, column: Int) {
        guard row > 0 && row < numberOfRows
            && column > 0  && column < numberOfColumns else {
                return
        }

        grid[row][column] = unit
    }

    func clearMapUnitAt(row: Int, column: Int) {
        setMapUnitAt(MapUnit.EmptySpace, row: row, column: column)
    }

    func retrieveMapUnitAt(row: Int, column: Int) -> MapUnit? {
        guard row > 0 && row < numberOfRows
            && column > 0  && column < numberOfColumns else {
                return nil
        }
        return grid[row][column]
    }
}
