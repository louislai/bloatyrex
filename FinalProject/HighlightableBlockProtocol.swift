//
//  HighlightableBlockProtocol.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 17/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

/// Protocol for blocks that are highlightable. This is used for tracing which program blocks are
/// currently being ran on the programming interface of the game.

protocol HighlightableBlockProtocol {
    func highlight()
    func unhighlight()
}
