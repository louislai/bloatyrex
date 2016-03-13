//
//  CommandTree.swift
//  FinalProject
//
//  Created by louis on 13/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

protocol CommandTree {}

struct Sample {
    static let sampleProgram = Program.MultipleStatement(
        Statement.ActionStatement(Action.Forward),
        Program.MultipleStatement(
            Statement.ActionStatement(Action.RotateRight),
            Program.MultipleStatement(
                Statement.ActionStatement(Action.Forward),
                Program.MultipleStatement(
                    Statement.ActionStatement(Action.Forward),
                    Program.MultipleStatement(
                        Statement.ActionStatement(Action.Forward),
                        Program.MultipleStatement(
                            Statement.ActionStatement(Action.Forward),
                            Program.MultipleStatement(
                                Statement.ActionStatement(Action.Forward),
                                Program.MultipleStatement(
                                    Statement.ActionStatement(Action.Forward),
                                    Program.MultipleStatement(
                                        Statement.ActionStatement(Action.Forward),
                                        Program.MultipleStatement(
                                            Statement.ActionStatement(Action.RotateRight),
                                            Program.SingleStatement(
                                                Statement.ActionStatement(Action.Forward)
                                            )
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    )
}
