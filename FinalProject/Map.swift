//
//  Map.swift
//  FinalProject
//
//  Created by louis on 10/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// The map model for holding the unit nodes
/// Represented as a 2D array of MapUnitNode
///
/// Public Properties:
/// - grid: the 2D array of MapUnitNode
/// - numberOfRows: the number of rows in the grid
/// - numberOfColumns: the number of columns in the grid

import Foundation

class Map: NSObject, NSCoding {
    var grid: [[MapUnitNode]]
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

    required init?(coder aDecoder: NSCoder) {
        self.grid = aDecoder.decodeObjectForKey("Grid") as! [[MapUnitNode]]
        self.numberOfRows = aDecoder.decodeIntegerForKey("NumberOfRows")
        self.numberOfColumns = aDecoder.decodeIntegerForKey("NumberOfColumns")
        super.init()
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(grid, forKey: "Grid")
        aCoder.encodeInteger(numberOfRows, forKey: "NumberOfRows")
        aCoder.encodeInteger(numberOfColumns, forKey: "NumberOfColumns")
    }

    /// Replace the unit at a row & column in the grid with another unit
    func setMapUnitAt(unit: MapUnitNode, row: Int, column: Int) {
        guard row >= 0 && row < numberOfRows
            && column >= 0  && column < numberOfColumns else {
                return
        }

        grid[row][column] = unit
    }

    /// Set a particular row & column in the grid to EmptySpace
    func clearMapUnitAt(row: Int, column: Int) {
        setMapUnitAt(MapUnitNode(), row: row, column: column)
    }

    /// Retrieve the map unit at a row & column
    /// Return nil if row & column out of range
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
        for row in 0..<numberOfRows {
            for column in 0..<numberOfColumns {
                copy.grid[row][column] = grid[row][column].copy() as! MapUnitNode
            }
        }
        return copy
    }
}
