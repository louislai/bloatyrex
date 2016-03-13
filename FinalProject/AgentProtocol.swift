//
//  AgentProtocol.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 13/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

enum Direction {
    case Up
    case Down
    case Left
    case Right
}

enum Observation {
    case LookForward
}

protocol AgentProtocol {
    var x: Int { get set }
    var y: Int { get set }
    var direction: Direction { get set }
}