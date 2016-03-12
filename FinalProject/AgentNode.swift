//
//  Agent.swift
//  FinalProject
//
//  Created by louis on 12/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import SpriteKit

class AgentNode: SKSpriteNode {
    var orientation = Direction.North
    var map: Map!
    var row: Int!
    var column: Int!
    var delegate: LanguageDelegate!

    func setOrientationTo(direction: Direction) {
        orientation = direction
    }

    func moveForward() {

    }

    private func nextPosition() -> (row: Int, column: Int)? {

    }
}
