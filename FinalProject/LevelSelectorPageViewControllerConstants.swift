//
//  LevelSelectorPageViewControllerConstants.swift
//  BloatyRex
//
//  Created by louis on 21/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

struct LevelSelectorPageViewControllerConstants {
    static let headerText = "Tap to load level, Press-and-hold for Settings"
    static let searchingText = "Search for file name..."
    
    struct Position {
        static let searching = CGRect(x: 0, y: 0, width: 1024, height: 60)
        static let navigation = CGRect(x: 0, y: 60, width: 1024, height: 50)
        static let pageController = CGRect(x: 0, y: 60, width: 1024, height: 708)
    }
}
