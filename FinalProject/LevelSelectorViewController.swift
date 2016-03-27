//
//  LevelSelectorViewController.swift
//  FinalProject
//
//  Created by Melvin Tan Jun Keong on 23/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import UIKit

class LevelSelectorViewController: UIViewController, UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    var pageIndex: Int?
    var fileNames: [String]?
    var previousViewController: UIViewController?
    var pageViewController: UIViewController?
    private let filesArchive = FilesArchive()
    var loadedMap: Map! = nil
    private let reuseIdentifier = "LevelCellIdentifier"
    private let sectionInsets = UIEdgeInsets(top: 100.0, left: 10.0, bottom: 100.0, right: 10.0)

    override func viewDidLoad() {
        super.viewDidLoad()

        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        collectionView.registerClass(LevelCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView)
    }

    // Make this number of cell
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return fileNames!.count
    }

    // Make cell and return cell
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier,
            forIndexPath: indexPath) as! LevelCell
        cell.levelSelectorViewController = self
        cell.levelSelectorPageViewController = pageViewController as! LevelSelectorPageViewController
        cell.textLabel.text = fileNames![indexPath.item]
        cell.textLabel.textColor = UIColor.whiteColor()
        cell.textLabel.font = UIFont(name: "Courier", size: 18)
        cell.backgroundColor = UIColor.darkGrayColor()
        return cell
    }

    // When the user tapped a cell, it loads the file with the corresponding file name.
    func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! LevelCell
        let fileName = cell.textLabel.text!
        if let loadedMap = filesArchive.loadFromPropertyList(fileName) {
            let levelDesigningViewController = previousViewController as! LevelDesigningViewController
            levelDesigningViewController.map = loadedMap
            levelDesigningViewController.viewDidLoad()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 325, height: 100)
    }

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

class LevelCell: UICollectionViewCell {
    var textLabel: UILabel!
    private var filesArchive = FilesArchive()
    private var levelSelectorViewController: LevelSelectorViewController!
    private var levelSelectorPageViewController: LevelSelectorPageViewController!
    override init(frame: CGRect) {
        super.init(frame: frame)

        let labelHeight = frame.size.height/3
        textLabel = UILabel(frame: CGRect(x: 0, y: labelHeight, width: frame.size.width, height: labelHeight))
        textLabel.textAlignment = .Center
        contentView.addSubview(textLabel)

        addGesturesToContentView()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    func addGesturesToContentView() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(LevelCell.handleLongPressedCell(_:)))
        contentView.addGestureRecognizer(longPressGestureRecognizer)
        contentView.userInteractionEnabled = true
    }

    // When the user long-pressed a cell, the user can choose to delete the file with the corresponding file name.
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
            self.filesArchive.removePropertyList(fileName)
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
        levelSelectorViewController.presentViewController(deleteAlert, animated: true, completion: nil)
    }

    func renameFile() {
        let originalFileName = textLabel.text!
        var newName: UITextField?
        var renamedSuccessfully = false
        let renameAlert = UIAlertController(title: "Rename", message: "Rename '\(originalFileName)' as?",
            preferredStyle: UIAlertControllerStyle.Alert)
        renameAlert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            newName = textField
            newName?.placeholder = "Enter new name here"
        }
        renameAlert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
            if newName!.text!.characters.count <= 30 {
                renamedSuccessfully = self.filesArchive.renamePropertyList(originalFileName, newFileName: newName!.text!)
            }
            if renamedSuccessfully {
                let successAlert = UIAlertController(title: "Renamed!", message: "You have successfully renamed this level!",
                    preferredStyle: UIAlertControllerStyle.Alert)
                successAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                    self.levelSelectorPageViewController.resetNavigationBar()
                    self.resetSearchBar()
                    self.reloadPageViewController()
                }))
                self.levelSelectorPageViewController.presentViewController(successAlert, animated: true, completion: nil)
            } else {
                let failureAlert = UIAlertController(title: "Failed", message: "Failed to save this level.",
                    preferredStyle: UIAlertControllerStyle.Alert)
                failureAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                    self.levelSelectorPageViewController.resetNavigationBar()
                }))
                self.levelSelectorPageViewController.presentViewController(failureAlert, animated: true, completion: nil)
            }
        }))
        renameAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            self.levelSelectorPageViewController.resetNavigationBar()
        }))
        levelSelectorPageViewController.presentViewController(renameAlert, animated: true, completion: nil)
    }

    func reloadPageViewController() {
        levelSelectorPageViewController.filtered = []
        levelSelectorPageViewController.viewDidAppear(false)
    }

    // Mark: - Search Bar

    var searchBar: UISearchBar {
        return levelSelectorPageViewController.searchBar
    }

    func resetSearchBar() {
        searchBar.text = ""
    }

    // MARK: - Navigation Bar

    var navigationBar: UINavigationBar {
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

    func setNavigationBar(fileName: String) {
        let navigationItem = navigationBar.items!.first!
        navigationItem.title = fileName
        navigationItem.leftBarButtonItem = renameButton
        navigationItem.rightBarButtonItem = deleteButton
        navigationBar.items = [navigationItem]
    }
}
