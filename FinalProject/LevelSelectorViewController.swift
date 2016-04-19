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
    private var sectionInsets = UIEdgeInsets(top: 100.0, left: 10.0, bottom: 100.0, right: 10.0)

    override func viewDidLoad() {
        super.viewDidLoad()

        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        collectionView.registerClass(LevelCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(red: 0, green: 0.9, blue: 0, alpha: 0.2)
        self.view.addSubview(collectionView)

        // different configuration when used from the package selector
        if let previousController = previousViewController as? PackageSelectorViewController {
            sectionInsets = UIEdgeInsets(top: 100.0, left: 10.0, bottom: 100.0, right: 10.0)

            // add title
            let title = UILabel(frame: CGRect(x: 0, y: 0, width: 1024, height: 80))
            title.textAlignment = .Center
            title.text = previousController.selectedPackageTitle
            title.textColor = GlobalConstants.Font.defaultGreen
            title.font = UIFont(name: "\(GlobalConstants.Font.defaultName)-Bold", size: 48)
            collectionView.addSubview(title)

            // add back button
            let backButtonImage = UIImage(named: "back") as UIImage?
            let backButton = UIButton(type: UIButtonType.Custom) as UIButton
            backButton.frame = CGRect(x: 20, y: 590, width: 73, height: 73)
            backButton.setImage(backButtonImage, forState: .Normal)
            backButton.addTarget(self,
                action: #selector(LevelSelectorViewController.backButtonAction(_:)),
                forControlEvents: .TouchUpInside)
            collectionView.addSubview(backButton)
        }
    }

    func backButtonAction(sender: UIButton!) {
        navigationController?.popViewControllerAnimated(true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? PlayingViewController {
            destination.map = loadedMap
        }
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
        if previousViewController is LevelDesigningViewController {
            cell.addGesturesToContentView()
        }
        return cell
    }

    // When the user tapped a cell, it loads the file with the corresponding file name.
    func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! LevelCell
        let fileName = cell.textLabel.text!
        if let loadedMap = filesArchive.loadFromFile(fileName) {
            if previousViewController is LevelDesigningViewController {
                let levelDesigningViewController = previousViewController as! LevelDesigningViewController
                levelDesigningViewController.map = loadedMap
                for row in 0...loadedMap.numberOfRows {
                    for column in 0...loadedMap.numberOfColumns {
                        if let node = loadedMap.retrieveMapUnitAt(row, column: column) {
                            if node.type == MapUnitType.Agent {
                                levelDesigningViewController.agentNode = node as! AgentNode
                                levelDesigningViewController.agentRow = row
                                levelDesigningViewController.agentColumn = column
                                break
                            }
                        }
                    }
                }
                levelDesigningViewController.viewDidLoad()
                dismissViewControllerAnimated(true, completion: nil)
            } else if previousViewController is PackageSelectorViewController {
                /// load selected level to play
                self.loadedMap = loadedMap
                performSegueWithIdentifier("loadLevelToPlay", sender: self)
            }
        }
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

        let background = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        background.image = UIImage(named: "toilet-paper")
        contentView.addSubview(background)
        let labelHeight = frame.size.height/3
        textLabel = UILabel(frame: CGRect(x: 0, y: labelHeight, width: frame.size.width, height: labelHeight))
        textLabel.textAlignment = .Center
        textLabel.textColor = GlobalConstants.Font.defaultGreen
        textLabel.font = UIFont(name: GlobalConstants.Font.defaultNameBold, size: 17)
        contentView.addSubview(textLabel)
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
                renamedSuccessfully = self.filesArchive.renameFile(originalFileName, newFileName: newName!.text!)
            }
            if renamedSuccessfully {
                self.levelSelectorPageViewController.resetNavigationBar()
                self.resetSearchBar()
                self.reloadPageViewController()
                let successAlert = UIAlertController(title: "Renamed!", message: "You have successfully renamed this level!",
                    preferredStyle: UIAlertControllerStyle.Alert)
                successAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
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
    var backButton: UIBarButtonItem {
        return UIBarButtonItem(title: "< Back", style: .Plain, target: self,
                               action: #selector(resetNavigationBar))
    }

    func resetNavigationBar() {
        self.levelSelectorPageViewController.resetNavigationBar()
        self.resetSearchBar()
        self.reloadPageViewController()
    }

    func setNavigationBar(fileName: String) {
        let navigationItem = navigationBar!.items!.first!
        navigationItem.title = fileName
        navigationItem.leftBarButtonItems = [backButton, renameButton]
        navigationItem.rightBarButtonItem = deleteButton
        navigationBar?.items = [navigationItem]
    }
}
