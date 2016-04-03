//
//  Constants.swift
//  FinalProject
//
//  Created by louis on 26/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import UIKit

class GlobalConstants {
    struct SegueIdentifier {
        static let designToPlaying = "DesignToPlayingSegue"
    }

    struct Dimension {
        static let screenWidth = CGFloat(1024)
        static let screenHeight = CGFloat(768)
        static let blockWidth = CGFloat(40)
        static let blockHeight = CGFloat(40)
    }

    struct zPosition {
        static let front = CGFloat(2)
        static let back = CGFloat(1)
    }

    struct Notification {
        static let gameReset = "reset"
        static let gameResetAndRun = "resetAndRun"
        static let gameWon = "won"
    }
    
    static let filesArchive = FilesArchive()
}
