//
//  LevelSelectorViewController.swift
//  FinalProject
//
//  Created by Melvin Tan Jun Keong on 23/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import UIKit

class LevelSelectorViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
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
    
    /// Make this number of cell
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return fileNames!.count
    }
    
    /// Make cell and return cell
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
    
    /// When the user tapped a cell, it loads the file with the corresponding file name.
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
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("handleLongPressedCell:"))
        contentView.addGestureRecognizer(longPressGestureRecognizer)
        contentView.userInteractionEnabled = true
    }
    
    /// When the user long-pressed a cell, the user can choose to delete the file with the corresponding file name.
    func handleLongPressedCell(sender: UILongPressGestureRecognizer) {
        let tappedContentView = sender.view as UIView!
        let label = tappedContentView.subviews.first! as! UILabel
        let fileName = label.text!
        deleteFile(fileName)
    }
    
    /// Delete a file from FilesArchive given its fileName.
    func deleteFile(fileName: String) {
        let deleteAlert = UIAlertController(title: "Delete", message: "'\(fileName)' will be deleted. This action cannot be undone.", preferredStyle: UIAlertControllerStyle.Alert)
        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action: UIAlertAction!) in
            self.filesArchive.removePropertyList(fileName)
            self.levelSelectorPageViewController.viewDidLoad()
        }))
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        levelSelectorViewController.presentViewController(deleteAlert, animated: true, completion: nil)
    }
}