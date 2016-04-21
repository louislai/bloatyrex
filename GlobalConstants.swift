//
//  GlobalConstants.swift
//  FinalProject
//
//  Created by louis on 26/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// A Constant file holding the constants to be used by all classes in the project

import UIKit
import SpriteKit

class GlobalConstants {
    struct SegueIdentifier {
        static let designToPlaying = "DesignToPlayingSegue"
        static let playingToTutorial = "Hello"
    }

    struct Dimension {
        static let screenWidth = CGFloat(1024)
        static let screenHeight = CGFloat(768)
        static let blockWidth = CGFloat(50)
        static let blockHeight = CGFloat(50)
    }

    struct zPosition {
        static let front = CGFloat(2)
        static let back = CGFloat(1)
    }

    struct Identifier {
        static let playingViewController = "PlayingViewController"
        static let programmingViewController = "ProgrammingViewController"
    }

    struct Notification {
        static let gameReset = "reset"
        static let gameResetAndRun = "resetAndRun"
        static let gameWon = "won"
        static let gameWonInfoIsPlayingPresetMap = "isPlayingPresetMap"
        static let gameWonInfoRating = "gameRating"
    }

    struct Font {
        static let defaultName = "ChalkboardSE"
        static let defaultNameBold = "ChalkboardSE-Bold"
        static let defaultGreen = SKColor(red: 0, green: 0.5, blue: 0, alpha: 1)
    }

    struct CodeBlocks {
        static let blockSectionButtonsPerRow = 3
        static let blockSize = CGFloat(50)
        static let blockSectionMargin = CGFloat(10)
        static let blockSectionTitleHeight = CGFloat(64)
        static let blockSectionWidth = CGFloat(blockSectionButtonsPerRow) * (blockSize + blockSectionMargin) + blockSectionMargin
        static let blockSectionTitleSize = CGFloat(32)
    }

    struct ImageNames {
        static let poo = "poo"
        static let agent = "agent"
        static let monster = "monster"
        static let space = "space"
        static let buttons_default = "buttons-unknown"
        static let buttons_left = "buttons-left"
        static let buttons_right = "buttons-right"
        static let wooden_block = "wooden-block"
        static let hole = "hole"
        static let wall = "wall"
        static let goal = "toilet"
    }

    static let filesArchive = FilesArchive()
    static let customLevelName = "Free Play"


    static let PrepackageNames = ["The Basics", "If", "While"]
    static let PrepackagedLevelsNames: [[String]] = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
        ["1", "2", "3", "4", "5"],
        ["1", "2", "3", "4", "5", "6"]
    ]

    static let BasicLevelsWithImages = ["1", "2", "3", "4", "6"]
    static let IfLevelsWithImages = ["1", "2"]
    static let WhileLevelsWithImages = ["1"]
}
