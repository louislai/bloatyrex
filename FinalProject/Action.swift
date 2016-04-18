//
//  Action.swift
//  FinalProject
//
//  Created by louis on 10/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

enum Action {
    case NoAction
    case Forward(HighlightableBlockProtocol?)
    case RotateLeft(HighlightableBlockProtocol?)
    case RotateRight(HighlightableBlockProtocol?)
    case Jump(HighlightableBlockProtocol?)
    case ChooseButton(Int, HighlightableBlockProtocol?)
}
