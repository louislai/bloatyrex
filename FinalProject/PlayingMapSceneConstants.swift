//
//  PlayingMapSceneConstants.swift
//  BloatyRex
//
//  Created by louis on 20/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// A list of constants to be used by PlayingMapScene

import UIKit

struct PlayingMapSceneConstants {
    struct LabelText {
        static let play = "Play"
        static let pause = "Pause"
        static let reset = "Reset"
        static let resetHint = "Rewind to try"
    }
    struct ButtonSpriteName {
        static let play = "play"
        static let pause = "pause"
        static let reset = "rewind"
        static let back = "back"
    }
    static let buttonYPosition = CGFloat(-334)
    static let buttonDimension = CGFloat(60)
    static let timePerMove: CFTimeInterval = 1.0
}
