//
//  FilesArchive.swift
//  LevelDesigner
//
//  Created by Melvin Tan Jun Keong on 31/1/16.
//  Copyright © 2016 NUS CS3217. All rights reserved.
//
/// FileArchive is responsible for managing level files

import Foundation

class FilesArchive: NSObject {

    override init() {}

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
        let mapFiles = filesInDirectory.filter { ($0 as NSString).pathExtension == "map" }
        let mapFileNames = mapFiles.map { ($0 as NSString).stringByDeletingPathExtension }
        return mapFileNames
    }

    // Save Map into a file with given name.
    // Returns: true if save is successful, false otherwise.
    func saveToFile(map: Map, name: String) -> Bool {
        if name.isEmpty {
            return false
        } else {
            let filePath = (documentDirectory as AnyObject).stringByAppendingPathComponent(name + ".map")

            let data = NSMutableData()
            let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
            archiver.encodeObject(map)
            archiver.finishEncoding()
            return data.writeToFile(filePath, atomically: true)
        }
    }

    // Reconstruct Map for a given filePath
    // Returns: Map if filePath exist, nil otherwise
    func loadFromFile(fileName: String) -> Map? {
        var filePath: String
        let mapExtension = ".map"
        if fileName.containsString(mapExtension) {
            filePath = fileName
        } else {
            filePath = (documentDirectory as AnyObject).stringByAppendingPathComponent(fileName + ".map")
        }
        guard let data = NSFileManager.defaultManager().contentsAtPath(filePath) else {
            return nil
        }
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        guard let map = unarchiver.decodeObject() as? Map else {
                return nil
        }
        return map
    }

    // Remove the map file from the directory
    func removeFile(fileName: String) {
        let filePath = (documentDirectory as AnyObject).stringByAppendingPathComponent(fileName + ".map")
        do {
            try NSFileManager.defaultManager().removeItemAtPath(filePath)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    // Rename the original plist filename from the directory with the new plist filename
    func renameFile(originalFileName: String, newFileName: String) -> Bool {
        if newFileName.isEmpty {
            return false
        } else {
            var success: Bool?
            let originalFilePath = (documentDirectory as AnyObject).stringByAppendingPathComponent(originalFileName + ".map")
            let newFilePath = (documentDirectory as AnyObject).stringByAppendingPathComponent(newFileName + ".map")
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
