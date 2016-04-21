//
//  LevelCell.swift
//  BloatyRex
//
//  Created by Tham Zheng Yi on 21/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation
import UIKit

class LevelCell: UICollectionViewCell {
    var textLabel: UILabel!
    private var filesArchive = FilesArchive()
    private var levelSelectorViewController: LevelSelectorViewController!
    private var levelSelectorPageViewController: LevelSelectorPageViewController!

    override init(frame: CGRect) {
        super.init(frame: frame)

        let labelHeight = frame.size.height / 3
        textLabel = UILabel(frame: CGRect(x: 0, y: labelHeight, width: frame.size.width, height: labelHeight))
        textLabel.textAlignment = .Center
        textLabel.textColor = UIColor.whiteColor()
        textLabel.font = UIFont(name: GlobalConstants.Font.defaultNameBold, size: 17)
        contentView.addSubview(textLabel)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    func addGesturesToContentView() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                      action: #selector(LevelCell.handleLongPressedCell(_:)))
        contentView.addGestureRecognizer(longPressGestureRecognizer)
        contentView.userInteractionEnabled = true
    }

    func setLevelSelectorViewController(controller: LevelSelectorViewController) {
        levelSelectorViewController = controller
    }

    func setLevelSelectorPageViewController(controller: LevelSelectorPageViewController) {
        levelSelectorPageViewController = controller
    }

    // When the user long-pressed a cell, the user can choose to delete the file with the
    // corresponding file name.
    func handleLongPressedCell(sender: UILongPressGestureRecognizer) {
        let tappedContentView = sender.view as UIView!
        let label = tappedContentView.subviews.first! as! UILabel
        let fileName = label.text!
        setNavigationBar(fileName)
    }

    // Delete a file from FilesArchive given its fileName.
    func deleteFile() {
        let fileName = textLabel.text!
        let deleteAlert = UIAlertController(title: "Delete",
                                            message: "'\(fileName)' will be deleted. This action cannot be undone.",
                                            preferredStyle: UIAlertControllerStyle.Alert)
        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action: UIAlertAction!) in
            self.filesArchive.removeFile(fileName)
            let successAlert = UIAlertController(title: "Deleted!",
                message: "You have successfully deleted \(fileName)!",
                preferredStyle: UIAlertControllerStyle.Alert)
            successAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                self.levelSelectorPageViewController.resetNavigationBar()
                self.resetSearchBar()
                self.reloadPageViewController()
            }))
            self.levelSelectorPageViewController.presentViewController(successAlert, animated: true, completion: nil)
        }))
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            self.levelSelectorPageViewController.resetNavigationBar()
        }))
        levelSelectorViewController.presentViewController(deleteAlert, animated: true,
                                                          completion: nil)
    }

    func renameFile() {
        let originalFileName = textLabel.text!
        var newName: UITextField?
        var renamedSuccessfully = false
        let renameAlert = UIAlertController(title: "Rename",
                                            message: "Rename '\(originalFileName)' as?",
                                            preferredStyle: UIAlertControllerStyle.Alert)
        renameAlert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            newName = textField
            newName?.placeholder = "Enter new name here"
        }
        renameAlert.addAction(UIAlertAction(title: "Confirm", style: .Default,
            handler: { (action: UIAlertAction!) in
                if newName!.text!.characters.count <= 30 {
                    renamedSuccessfully = self.filesArchive.renameFile(originalFileName,
                        newFileName: newName!.text!)
                }
                if renamedSuccessfully {
                    self.levelSelectorPageViewController.resetNavigationBar()
                    self.resetSearchBar()
                    self.reloadPageViewController()
                    let successAlert = UIAlertController(title: "Renamed!",
                        message: "You have successfully renamed this level!",
                        preferredStyle: UIAlertControllerStyle.Alert)
                    successAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.levelSelectorPageViewController.presentViewController(successAlert,
                        animated: true, completion: nil)
                } else {
                    let failureAlert = UIAlertController(title: "Failed",
                        message: "Failed to save this level.",
                        preferredStyle: UIAlertControllerStyle.Alert)
                    failureAlert.addAction(UIAlertAction(title: "OK", style: .Default,
                        handler: { (action: UIAlertAction!) in
                            self.levelSelectorPageViewController.resetNavigationBar()
                    }))
                    self.levelSelectorPageViewController.presentViewController(failureAlert,
                        animated: true, completion: nil)
                }
        }))
        renameAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel,
            handler: { (action: UIAlertAction!) in
                self.levelSelectorPageViewController.resetNavigationBar()
        }))
        levelSelectorPageViewController.presentViewController(renameAlert, animated: true,
                                                              completion: nil)
    }

    func reloadPageViewController() {
        levelSelectorPageViewController.filtered = []
        levelSelectorPageViewController.viewDidAppear(false)
    }

    // Mark: - Search Bar

    var searchBar: UISearchBar? {
        return levelSelectorPageViewController.searchBar
    }

    func resetSearchBar() {
        searchBar?.text = ""
    }

    // MARK: - Navigation Bar

    var navigationBar: UINavigationBar? {
        return levelSelectorPageViewController.navigationBar
    }

    var renameButton: UIBarButtonItem {
        return UIBarButtonItem(title: "Rename", style: .Plain, target: self,
                               action: #selector(LevelCell.renameFile))
    }
    var deleteButton: UIBarButtonItem {
        let trashBinImage = UIImage(named: "trash")
        return UIBarButtonItem(image: trashBinImage, style: .Plain, target: self,
                               action: #selector(LevelCell.deleteFile))
    }

    func resetNavigationBar() {
        self.levelSelectorPageViewController.resetNavigationBar()
        self.resetSearchBar()
        self.reloadPageViewController()
    }
    
    func setNavigationBar(fileName: String) {
        let navigationItem = navigationBar!.items!.first!
        navigationItem.title = fileName
        navigationItem.leftBarButtonItem = renameButton
        navigationItem.rightBarButtonItem = deleteButton
        navigationBar?.items = [navigationItem]
    }
}
