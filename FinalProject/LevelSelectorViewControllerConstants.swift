//
//  LevelSelectorViewControllerConstants.swift
//  BloatyRex
//
//  Created by Tham Zheng Yi on 22/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation
import UIKit

struct LevelSelectorViewControllerConstants {
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