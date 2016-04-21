//
//  LevelSelectorViewController.swift
//  FinalProject
//
//  Created by Melvin Tan Jun Keong on 23/3/16.
//  Copyright Â© 2016 nus.cs3217.2016Group6. All rights reserved.
//

import UIKit

struct LevelSelectorConstants {
    static let cellReuseIdentifier = "packageCell"
    static let loadLevelSegueIdentifier = "loadLevelToPlay"

    static let pooImage = UIImage(named: "poo")
    static let toiletPaperImage = UIImage(named: "toilet-paper")
    static let backImage = UIImage(named: "back")

    static let backGroundColor = UIColor(red: 0, green: 0.9, blue: 0, alpha: 0.2)
    static let cellBackgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)

    static let pooImageViewFrame = CGRect(x: 925, y: 590, width: 70, height: 70)
    static let toiletPaperImageViewFrame = CGRect(x: 800, y: 540, width: 120, height: 120)
    static let backButtonFrame = CGRect(x: 20, y: 590, width: 73, height: 73)

    static let cellCornerRadius: CGFloat = 10

    // standard level selector settings
    static let standardLevelSelectorItemSize = CGSize(width: 325, height: 100)
    static let standardLevelSelectorSectionInsets = UIEdgeInsets(
        top: 100.0, left: 10.0,
        bottom: 100.0, right: 10.0
    )
    static let standardLevelSelectorItemSpacing: CGFloat = 10
    static let standardLevelSelectorLineSpacing: CGFloat = 10

    // package level selector settings
    static let packageLevelSelectorTitleFontSize: CGFloat = 48
    static let packageLevelSelectorTitleFrame = CGRect(x: 0, y: 0, width: 1024, height: 80)
    static let packageLevelSelectorItemSize = CGSize(width: 100, height: 100)
    static let packageLevelSelectorSectionInsets = UIEdgeInsets(
        top: 100.0, left: 100.0,
        bottom: 100.0, right: 100.0
    )
    static let packageLevelSelectorItemSpacing: CGFloat = 100
    static let packageLevelSelectorLineSpacing: CGFloat = 50
}

class LevelSelectorViewController: UIViewController, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    var pageIndex: Int?
    var fileNames: [String]?
    var previousViewController: UIViewController?
    var pageViewController: UIViewController?
    private let filesArchive = FilesArchive()
    var loadedMap: Map! = nil
    var loadedMapFileName = GlobalConstants.customLevelName

    override func viewDidLoad() {
        super.viewDidLoad()

        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(
            frame: view.frame,
            collectionViewLayout: flowLayout
        )
        collectionView.registerClass(
            LevelCell.self,
            forCellWithReuseIdentifier: LevelSelectorConstants.cellReuseIdentifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = LevelSelectorConstants.backGroundColor
        self.view.addSubview(collectionView)

        // different configuration when used from the package selector
        if let previousController = previousViewController as? PackageSelectorViewController {
            // add title
            let title = UILabel(frame: LevelSelectorConstants.packageLevelSelectorTitleFrame)
            title.textAlignment = .Center
            title.text = previousController.selectedPackageTitle
            title.textColor = GlobalConstants.Font.defaultGreen
            title.font = UIFont(
                name: GlobalConstants.Font.defaultNameBold,
                size: LevelSelectorConstants.packageLevelSelectorTitleFontSize
            )
            collectionView.addSubview(title)
        }

        let pooImageView = UIImageView(frame: LevelSelectorConstants.pooImageViewFrame)
        pooImageView.image = LevelSelectorConstants.pooImage
        collectionView.addSubview(pooImageView)

        let toiletPaperImageView =
            UIImageView(frame: LevelSelectorConstants.toiletPaperImageViewFrame)
        toiletPaperImageView.image = LevelSelectorConstants.toiletPaperImage
        collectionView.addSubview(toiletPaperImageView)

        // add back button
        let backButtonImage = LevelSelectorConstants.backImage as UIImage?
        let backButton = UIButton(type: UIButtonType.Custom) as UIButton
        backButton.frame = LevelSelectorConstants.backButtonFrame
        backButton.setImage(backButtonImage, forState: .Normal)
        backButton.addTarget(
            self,
            action: #selector(LevelSelectorViewController.backButtonAction(_:)),
            forControlEvents: .TouchUpInside
        )
        collectionView.addSubview(backButton)
    }

    func backButtonAction(sender: UIButton!) {
        if previousViewController!.isKindOfClass(PackageSelectorViewController) {
            navigationController?.popViewControllerAnimated(true)
        } else {
            pageViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? PlayingViewController {
            let levelSelectorPageViewController =
                pageViewController as! LevelSelectorPageViewController
            destination.map = loadedMap
            destination.levelName = loadedMapFileName
            destination.packageName = levelSelectorPageViewController.package
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            LevelSelectorConstants.cellReuseIdentifier,
            forIndexPath: indexPath) as! LevelCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = LevelSelectorConstants.cellCornerRadius
        cell.setLevelSelectorViewController(self)
        cell.setLevelSelectorPageViewController(
            pageViewController as! LevelSelectorPageViewController)
        cell.backgroundColor = LevelSelectorConstants.cellBackgroundColor
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
        if previousViewController is LevelDesigningViewController {
            if let loadedMap = filesArchive.loadFromFile(fileName) {
                let levelDesigningViewController =
                    previousViewController as! LevelDesigningViewController
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
            }
        } else if previousViewController is PackageSelectorViewController {
            let levelSelectorPageViewController =
                pageViewController as! LevelSelectorPageViewController
            if let package = levelSelectorPageViewController.package {
                if let loadedMap = filesArchive.loadFromPackageFile(fileName,
                                                                    packageName: package) {
                    /// load selected level to play
                    self.loadedMap = loadedMap
                    self.loadedMapFileName = fileName
                    performSegueWithIdentifier(LevelSelectorConstants.loadLevelSegueIdentifier,
                                               sender: self)
                }
            }
        }
    }

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if previousViewController!.isKindOfClass(PackageSelectorViewController) {
            return LevelSelectorConstants.packageLevelSelectorItemSize
        } else {
            return LevelSelectorConstants.standardLevelSelectorItemSize
        }
    }

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if previousViewController!.isKindOfClass(PackageSelectorViewController) {
            return LevelSelectorConstants.packageLevelSelectorSectionInsets
        } else {
            return LevelSelectorConstants.standardLevelSelectorSectionInsets
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        if previousViewController!.isKindOfClass(PackageSelectorViewController) {
            return LevelSelectorConstants.packageLevelSelectorItemSpacing
        } else {
            return LevelSelectorConstants.standardLevelSelectorItemSpacing
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        if previousViewController!.isKindOfClass(PackageSelectorViewController) {
            return LevelSelectorConstants.packageLevelSelectorLineSpacing
        } else {
            return LevelSelectorConstants.standardLevelSelectorLineSpacing
        }
    }
}
