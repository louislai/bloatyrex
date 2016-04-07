//
//  Map.swift
//  FinalProject
//
//  Created by louis on 10/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

class Map: NSObject, NSCoding {
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
        for row in 0..<numberOfRows {
            for column in 0..<numberOfColumns {
                copy.grid[row][column] = grid[row][column].copy() as! MapUnitNode
            }
        }
        return copy
    }
}
