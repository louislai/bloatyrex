//
//  LevelSelectorViewController.swift
//  FinalProject
//
//  Created by Melvin Tan Jun Keong on 23/3/16.
//  Copyright Â© 2016 nus.cs3217.2016Group6. All rights reserved.
//
//  Displays the levels on the current page in the level selector.
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
            forCellWithReuseIdentifier: LevelSelectorViewControllerConstants.cellReuseIdentifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = LevelSelectorViewControllerConstants.backGroundColor
        self.view.addSubview(collectionView)

        // different configuration when used from the package selector
        if let previousController = previousViewController as? PackageSelectorViewController {
            // add title
            let title =
                UILabel(frame: LevelSelectorViewControllerConstants.packageLevelSelectorTitleFrame)
            title.textAlignment = .Center
            title.text = previousController.selectedPackageTitle
            title.textColor = GlobalConstants.Font.defaultGreen
            title.font = UIFont(
                name: GlobalConstants.Font.defaultNameBold,
                size: LevelSelectorViewControllerConstants.packageLevelSelectorTitleFontSize
            )
            collectionView.addSubview(title)
        }

        let pooImageView = UIImageView(
            frame: LevelSelectorViewControllerConstants.pooImageViewFrame)
        pooImageView.image = LevelSelectorViewControllerConstants.pooImage
        collectionView.addSubview(pooImageView)

        let toiletPaperImageView =
            UIImageView(frame: LevelSelectorViewControllerConstants.toiletPaperImageViewFrame)
        toiletPaperImageView.image = LevelSelectorViewControllerConstants.toiletPaperImage
        collectionView.addSubview(toiletPaperImageView)

        // add back button
        let backButtonImage = LevelSelectorViewControllerConstants.backImage as UIImage?
        let backButton = UIButton(type: UIButtonType.Custom) as UIButton
        backButton.frame = LevelSelectorViewControllerConstants.backButtonFrame
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
            LevelSelectorViewControllerConstants.cellReuseIdentifier,
            forIndexPath: indexPath) as! LevelCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = LevelSelectorViewControllerConstants.cellCornerRadius
        cell.setLevelSelectorViewController(self)
        cell.setLevelSelectorPageViewController(
            pageViewController as! LevelSelectorPageViewController)
        cell.backgroundColor = LevelSelectorViewControllerConstants.cellBackgroundColor
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
                    performSegueWithIdentifier(
                        LevelSelectorViewControllerConstants.loadLevelSegueIdentifier,
                        sender: self)
                }
            }
        }
    }

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if previousViewController!.isKindOfClass(PackageSelectorViewController) {
            return LevelSelectorViewControllerConstants.packageLevelSelectorItemSize
        } else {
            return LevelSelectorViewControllerConstants.standardLevelSelectorItemSize
        }
    }

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if previousViewController!.isKindOfClass(PackageSelectorViewController) {
            return LevelSelectorViewControllerConstants.packageLevelSelectorSectionInsets
        } else {
            return LevelSelectorViewControllerConstants.standardLevelSelectorSectionInsets
        }
    }

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        if previousViewController!.isKindOfClass(PackageSelectorViewController) {
            return LevelSelectorViewControllerConstants.packageLevelSelectorItemSpacing
        } else {
            return LevelSelectorViewControllerConstants.standardLevelSelectorItemSpacing
        }
    }

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        if previousViewController!.isKindOfClass(PackageSelectorViewController) {
            return LevelSelectorViewControllerConstants.packageLevelSelectorLineSpacing
        } else {
            return LevelSelectorViewControllerConstants.standardLevelSelectorLineSpacing
        }
    }
}
