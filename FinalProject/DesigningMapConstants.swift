//
//  DesigningMapConstants.swift
//  BloatyRex
//
//  Created by Melvin Tan Jun Keong on 19/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import UIKit

struct DesigningMapConstants {
    struct DefaultValue {
        struct Agent {
            static let numberOfMoves = 30
            static let orientation = Direction.Up
            static let numberOfRows = 0
            static let numberOfColumns = 0
        }
        struct Action {
            static let numberOfItemsPerPage = 15
            static let maximumNumberOfCharacters = 30
        }
    }
    struct Dimension {
        static let minNumberOfRows = 1
        static let minNumberOfColumns = 1

        static let maxNumberOfRows = 8
        static let maxNumberOfColumns = 8

        static let defaultNumberOfRows = 6
        static let defaultNumberOfColumns = 6

        static let paletteNumberOfRows = 4
        static let paletteNumberOfColumns = 8
    }
    struct Position {
        static let anchor = CGPoint(x: 0.5, y: 0.5)
        static let shiftLeft = CGFloat(-200)
        static let shiftUp = CGFloat(0)

        struct Palette {
            static let layer = CGPoint(x: 250, y: 150)
            static let label = CGPoint(x: 250, y: 280)
            static let summary = CGPoint(x: 250, y: -100)
        }

        struct Action {
            static let actionButtonY = -GlobalConstants.Dimension.screenHeight/2 + 40
            static let backButton = CGPoint(x: -GlobalConstants.Dimension.screenWidth/2 + 40,
                                            y: actionButtonY)
            static let testLevelButton = CGPoint(x: -100, y: actionButtonY)
            static let saveButton = CGPoint(x: 0, y: actionButtonY)
            static let loadButton = CGPoint(x: 100, y: actionButtonY)
            static let resetButton = CGPoint(x: GlobalConstants.Dimension.screenWidth/2 - 40,
                                             y: actionButtonY)
        }

        struct AgentSetting {
            static let agent = CGPoint(x: -25, y: 0)
            static let numberOfMovesLabel = CGPoint(x: 20, y: 0)
            static let incrementButton = CGPoint(x: 20, y: 35)
            static let decrementButton = CGPoint(x: 20, y: -35)
            static let background = CGPoint(x: -225, y: 300)
        }
    }
    struct Size {
        struct AgentSetting {
            static let button = CGSize(width: 30, height: 30)
            static let background = CGSize(width: 100, height: 100)
        }

        struct Palette {
            static let sprite = CGSize(width: 40, height: 40)
            static let cell = CGSize(width: 50, height: 50)
            static let background = CGSize(width: CGFloat(Dimension.paletteNumberOfColumns) * cell.width,
                                           height: CGFloat(Dimension.paletteNumberOfRows) * cell.height)
            static let summary = CGSize(width: 400, height: 120)
        }

        struct Action {
            static let button = CGSize(width: 60, height: 60)
        }
    }
    struct Alpha {
        static let opaque: CGFloat = 1
        static let translucent: CGFloat = 0.3
    }
    static let defaultGray = UIColor.grayColor().colorWithAlphaComponent(Alpha.translucent)
}
