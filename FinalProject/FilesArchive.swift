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

    // Returns: All the files' names in the given package's directory
    func getFileNamesFromPackage(packageName: String) -> [String] {
        var filesInDirectory = [NSString]()
        if let resourceURL = NSBundle.mainBundle().resourceURL {
            let packageURL = resourceURL.URLByAppendingPathComponent("Prepackaged Levels/\(packageName)")
            do {
                let URLsInDirectory = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(packageURL, includingPropertiesForKeys: nil, options: [])
                filesInDirectory = URLsInDirectory.map {
                    $0.lastPathComponent!
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        let packageMapFiles = filesInDirectory.filter { ($0 as NSString).pathExtension == "map" }
        var packageMapFileNameNumbers = packageMapFiles.map {
            Int(($0 as NSString).stringByDeletingPathExtension)!
        }
        packageMapFileNameNumbers.sortInPlace()
        let packageMapFileNames = packageMapFileNameNumbers.map { "\($0)" }
        return packageMapFileNames
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

    // Reconstruct PresetMap for a given filename and package name
    // Returns: PresetMap if filename and package name exist, nil otherwise
    func loadFromPackageFile(fileName: String, packageName: String) -> PresetMap? {
        if let resourceURL = NSBundle.mainBundle().resourceURL {
            let fileURL = resourceURL.URLByAppendingPathComponent(
                "Prepackaged Levels/\(packageName)/\(fileName).map")
            if let filePath = fileURL.path {
                guard let data = NSFileManager.defaultManager().contentsAtPath(filePath) else {
                    return nil
                }
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                guard let map = unarchiver.decodeObject() as? PresetMap else {
                    return nil
                }
                return map
            } else {
                return nil
            }
        } else {
            return nil
        }
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
