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
}

class PackageSelectorViewController: UICollectionViewController {
    private let reuseIdentifier = "packageCell"
    private let packageNames = ["The Basics", "Loops", "hi", "fish", "hi", "fish", "hi", "fish", "hi"]
    private let sectionInsets = UIEdgeInsets(top: 180,
        left: (GlobalConstants.Dimension.screenWidth - PackageSelectorConstants.cellWidth) / 2,
        bottom: 150.0, right: 5.0)
    private var cellWidth = PackageSelectorConstants.cellWidth
    private var cellHeight = PackageSelectorConstants.cellHeight
    private var selectedPackageTitle: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .Horizontal
            layout.minimumLineSpacing = GlobalConstants.Dimension.screenWidth / 2 -
                PackageSelectorConstants.cellWidth
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? LevelSelectorPageViewController {
            destination.currentStoryboard = self.storyboard
            destination.previousViewController = self
            destination.numberOfItemsPerPage = 15
            destination.package = selectedPackageTitle
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
        return packageNames.count
    }

    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier,
                       forIndexPath: indexPath) as! PackageCell
        let fullSizedImage = UIImage(named: "Yoshi-win")
        cell.imageView.image = fullSizedImage
        cell.packageTitle.text = packageNames[indexPath.item]
        cell.packageTitle.textColor = UIColor.whiteColor()
        cell.packageTitle.font = UIFont(name: GlobalConstants.Font.standardFontName, size: 38)
        cell.progressIndicator.text = "0/10"
        cell.progressIndicator.textColor = UIColor.whiteColor()
        cell.progressIndicator.font = UIFont(name: GlobalConstants.Font.standardFontName, size: 38)
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
            print(selectedPackageTitle)
        }
    }
}