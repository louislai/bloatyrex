//
//  FilesArchive.swift
//  LevelDesigner
//
//  Created by Melvin Tan Jun Keong on 31/1/16.
//  Copyright © 2016 NUS CS3217. All rights reserved.
//

import Foundation

class FilesArchive {

    init() {}

    private var documentDirectory: String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.UserDomainMask, true)
        return paths.first!
    }

    // Returns: All the files' name in the document directory.
    func getFileNames() -> [String] {
        var filesInDirectory = [NSString]()
        do {
            filesInDirectory = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(documentDirectory)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        let propertyListFiles = filesInDirectory.filter { ($0 as NSString).pathExtension == "plist" }
        let propertyListFileNames = propertyListFiles.map { ($0 as NSString).stringByDeletingPathExtension }
        return propertyListFileNames
    }

    // Save Map into a .plist file with given name.
    // Returns: true if save is successful, false otherwise.
    func saveToPropertyList(map: Map, name: String) -> Bool {
        if name.isEmpty {
            return false
        } else {
            let filePath = (documentDirectory as AnyObject).stringByAppendingPathComponent(name + ".plist")

            let dictionary = NSMutableDictionary()
            dictionary.setObject(map.numberOfRows, forKey: "Number Of Rows")
            dictionary.setObject(map.numberOfColumns, forKey: "Number Of Columns")
            for row in 0..<map.numberOfRows {
                for column in 0..<map.numberOfColumns {
                    let value = map.retrieveMapUnitAt(row, column: column)!.rawValue
                    dictionary.setObject(value, forKey: "\([row, column])")
                }
            }
            let isSaved = dictionary.writeToFile(filePath, atomically: true)
            return isSaved
        }
    }

    // Reconstruct Map for a given filePath
    // Returns: Map if filePath exist, nil otherwise
    func loadFromPropertyList(fileName: String) -> Map? {
        var filePath: String
        let plistExtension = ".plist"
        if fileName.containsString(plistExtension) {
            filePath = fileName
        } else {
            filePath = (documentDirectory as AnyObject).stringByAppendingPathComponent(fileName + ".plist")
        }
        var map: Map? = nil
        if var dictionary = NSDictionary(contentsOfFile: filePath) as? [String: AnyObject] {
            let rows = dictionary.removeValueForKey("Number Of Rows") as! Int
            let columns = dictionary.removeValueForKey("Number Of Columns") as! Int
            map = Map(numberOfRows: rows, numberOfColumns: columns)
            for arrayString in dictionary.keys {
                let coordinatesArrayString = String(arrayString.characters.filter { $0 != "[" && $0 != "]" })
                let coordinatesArray = coordinatesArrayString.componentsSeparatedByString(", ")
                let row = Int(coordinatesArray[0])!
                let column = Int(coordinatesArray[1])!
                let typeValue = dictionary[arrayString]! as! Int
                switch typeValue {
                case MapUnit.Agent.rawValue:
                    map!.setMapUnitAt(MapUnit.Agent, row: row, column: column)
                case MapUnit.EmptySpace.rawValue:
                    map!.setMapUnitAt(MapUnit.EmptySpace, row: row, column: column)
                case MapUnit.Goal.rawValue:
                    map!.setMapUnitAt(MapUnit.Goal, row: row, column: column)
                case MapUnit.Wall.rawValue:
                    map!.setMapUnitAt(MapUnit.Wall, row: row, column: column)
                default:
                    break
                }
            }
        }
        return map
    }

    // Remove the plist file from the directory
    func removePropertyList(fileName: String) {
        let filePath = (documentDirectory as AnyObject).stringByAppendingPathComponent(fileName + ".plist")
        do {
            try NSFileManager.defaultManager().removeItemAtPath(filePath)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    // Rename the original plist filename from the directory with the new plist filename
    func renamePropertyList(originalFileName: String, newFileName: String) -> Bool {
        if newFileName.isEmpty {
            return false
        } else {
            var success: Bool?
            let originalFilePath = (documentDirectory as AnyObject).stringByAppendingPathComponent(originalFileName + ".plist")
            let newFilePath = (documentDirectory as AnyObject).stringByAppendingPathComponent(newFileName + ".plist")
            do {
                try NSFileManager.defaultManager().moveItemAtPath(originalFilePath, toPath: newFilePath)
                success = true
            } catch let error as NSError {
                print(error.localizedDescription)
                success = false
            }
            return success!
        }
    }
}
