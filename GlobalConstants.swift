//
//  GlobalConstants.swift
//  FinalProject
//
//  Created by louis on 26/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import UIKit
import SpriteKit

class GlobalConstants {
    struct SegueIdentifier {
        static let designToPlaying = "DesignToPlayingSegue"
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
    static let filesArchive = FilesArchive()
}
