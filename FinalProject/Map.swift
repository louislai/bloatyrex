//
//  Map.swift
//  FinalProject
//
//  Created by louis on 10/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

class Map: NSObject {
    private var grid: [[MapUnitNode]]
    let numberOfRows: Int
    let numberOfColumns: Int

    init(numberOfRows: Int, numberOfColumns: Int) {
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
        self.grid = [[MapUnitNode]](
            count: numberOfRows,
            repeatedValue: [MapUnitNode](
                count: numberOfColumns,
                repeatedValue: MapUnitNode()
            )
        )
    }

    func setMapUnitAt(unit: MapUnitNode, row: Int, column: Int) {
        guard row >= 0 && row < numberOfRows
            && column >= 0  && column < numberOfColumns else {
                return
        }

        grid[row][column] = unit
    }

    func clearMapUnitAt(row: Int, column: Int) {
        setMapUnitAt(MapUnitNode(), row: row, column: column)
    }

    func retrieveMapUnitAt(row: Int, column: Int) -> MapUnitNode? {
        guard row >= 0 && row < numberOfRows
            && column >= 0  && column < numberOfColumns else {
                return nil
        }
        return grid[row][column]
    }
}

extension Map: NSCopying {
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Map(numberOfRows: numberOfRows, numberOfColumns: numberOfColumns)
        copy.grid = grid
        return copy
    }
}
