//
//  Action.swift
//  FinalProject
//
//  Created by louis on 10/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

enum Action: Equatable {
    case NoAction(HighlightableBlockProtocol?)
    case Forward(HighlightableBlockProtocol?)
    case RotateLeft(HighlightableBlockProtocol?)
    case RotateRight(HighlightableBlockProtocol?)
    case Jump(HighlightableBlockProtocol?)
    case ChooseButton(Int, HighlightableBlockProtocol?)
}

// MARK: Equatable
func == (lhs: Action, rhs: Action) -> Bool {
    switch (lhs, rhs) {
    case (.NoAction(_), .NoAction(_)):
        return true
    case (.Forward(_), .Forward(_)):
        return true
    case (.RotateLeft(_), .RotateLeft(_)):
        return true
    case (.RotateRight(_), .RotateRight(_)):
        return true
    case (.Jump(_), .Jump(_)):
        return true
    case (let .ChooseButton(buttonNumber1, _), let .ChooseButton(buttonNumber2,_)):
        return buttonNumber1 == buttonNumber2
    default: return false
    }
}
