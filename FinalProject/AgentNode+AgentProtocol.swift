//
//  AgentNode+AgentProtocol.swift
//  FinalProject
//
//  Created by louis on 18/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

extension AgentNode: AgentProtocol {
    var xPosition: Int {
        return column
    }
    var yPosition: Int {
        return row
    }
    var direction: Direction {
        return orientation
    }
}
