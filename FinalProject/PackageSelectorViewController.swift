//
//  PackageSelectorViewController.swift
//  FinalProject
//
//  Created by Tham Zheng Yi on 17/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation
import UIKit

class PackageSelectorViewController: UICollectionViewController {
    private let reuseIdentifier = "packageCell"
    private let packageNames = ["hi", "fish", "hi", "fish", "hi", "fish", "hi", "fish", "hi"]
    private let thumbnailSize: CGFloat = 300.0
    private let sectionInsets = UIEdgeInsets(top: 180, left: 400.0, bottom: 10.0, right: 5.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: GlobalConstants.Dimension.screenWidth / 3,
                                     height: GlobalConstants.Dimension.screenWidth / 3)
            layout.scrollDirection = .Horizontal
            layout.minimumLineSpacing = 200
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

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
        let fullSizedImage = UIImage(named: "eyes")
        cell.imageView.image = fullSizedImage
        return cell
    }
}

// MARK:UICollectionViewDelegateFlowLayout
extension PackageSelectorViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: thumbnailSize, height: thumbnailSize)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}