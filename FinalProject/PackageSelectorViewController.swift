//
//  PackageSelectorViewController.swift
//  FinalProject
//
//  Created by Tham Zheng Yi on 17/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation
import UIKit

struct PackageSelectorConstants {
    static let cellWidth: CGFloat = 300.0
    static let cellHeight: CGFloat = 400.0
    static let cellFontSize: CGFloat = 38
    static let cellImage = UIImage(named: GlobalConstants.ImageNames.winning)
    static let cellReuseIdentifier = "packageCell"

    static let levelSelectorItemsPerPage = 12
}

class PackageSelectorViewController: UICollectionViewController {
    private let sectionInsets = UIEdgeInsets(top: 50,
        left: (GlobalConstants.Dimension.screenWidth - PackageSelectorConstants.cellWidth) / 2,
        bottom: 50,
        right: (GlobalConstants.Dimension.screenWidth - PackageSelectorConstants.cellWidth) / 2)
    private var cellWidth = PackageSelectorConstants.cellWidth
    private var cellHeight = PackageSelectorConstants.cellHeight
    var selectedPackageTitle: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .Horizontal
            layout.minimumLineSpacing = GlobalConstants.Dimension.screenWidth / 2 -
                PackageSelectorConstants.cellWidth
        }
        self.collectionView!.backgroundColor = UIColor.whiteColor()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? LevelSelectorPageViewController {
            destination.package = selectedPackageTitle
            destination.previousViewController = self
            destination.numberOfItemsPerPage = PackageSelectorConstants.levelSelectorItemsPerPage
        }
    }
}

// MARK: UICollectionViewDataSource
extension PackageSelectorViewController {
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return GlobalConstants.PrepackageNames.count
    }

    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            PackageSelectorConstants.cellReuseIdentifier,
            forIndexPath: indexPath) as! PackageCell
        cell.imageView.image = PackageSelectorConstants.cellImage
        cell.packageTitle.text = GlobalConstants.PrepackageNames[indexPath.item]
        cell.packageTitle.textColor = UIColor.whiteColor()
        cell.packageTitle.font = UIFont(name: GlobalConstants.Font.defaultName,
                                        size: PackageSelectorConstants.cellFontSize)
        cell.packageTitle.font =
            cell.packageTitle.font.fontWithSize(PackageSelectorConstants.cellFontSize)
        cell.progressIndicator.text =
            "\(GlobalConstants.PrepackagedLevelsNames[indexPath.item].count) levels"
        cell.progressIndicator.textColor = UIColor.whiteColor()
        cell.progressIndicator.font = UIFont(name: GlobalConstants.Font.defaultName,
                                             size: PackageSelectorConstants.cellFontSize)
        cell.progressIndicator.font =
            cell.progressIndicator.font.fontWithSize(PackageSelectorConstants.cellFontSize)
        cell.backgroundColor = UIColor.darkGrayColor()
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension PackageSelectorViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

// MARK: UICollectionViewDelegate
extension PackageSelectorViewController {
    override func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        if let packageCell = cell as? PackageCell {
            selectedPackageTitle = packageCell.packageTitle.text
            self.performSegueWithIdentifier(
                GlobalConstants.SegueIdentifier.levelSelector,
                sender: self)
        }
    }
}
