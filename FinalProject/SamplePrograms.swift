//
//  CommandTree.swift
//  FinalProject
//
//  Created by louis on 13/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

struct Sample {
    static let sampleProgram = Program.MultipleStatement(
        Statement.ActionStatement(Action.Forward(nil)),
        Program.MultipleStatement(
            Statement.ActionStatement(Action.RotateRight(nil)),
            Program.MultipleStatement(
                Statement.ActionStatement(Action.Forward(nil)),
                Program.MultipleStatement(
                    Statement.ActionStatement(Action.Forward(nil)),
                    Program.MultipleStatement(
                        Statement.ActionStatement(Action.Forward(nil)),
                        Program.MultipleStatement(
                            Statement.ActionStatement(Action.Forward(nil)),
                            Program.MultipleStatement(
                                Statement.ActionStatement(Action.Forward(nil)),
                                Program.MultipleStatement(
                                    Statement.ActionStatement(Action.Forward(nil)),
                                    Program.MultipleStatement(
                                        Statement.ActionStatement(Action.Forward(nil)),
                                        Program.MultipleStatement(
                                            Statement.ActionStatement(Action.RotateRight(nil)),
                                            Program.SingleStatement(
                                                Statement.ActionStatement(Action.Forward(nil))
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

    static let sampleProgram2 = Program.MultipleStatement(
            Statement.ActionStatement(Action.RotateRight(nil)),
            Program.MultipleStatement(
                Statement.ActionStatement(Action.Forward(nil)),
                Program.MultipleStatement(
                    Statement.ActionStatement(Action.Forward(nil)),
                    Program.MultipleStatement(
                        Statement.ActionStatement(Action.Forward(nil)),
                        Program.MultipleStatement(
                            Statement.ActionStatement(Action.Forward(nil)),
                            Program.MultipleStatement(
                                Statement.ActionStatement(Action.Forward(nil)),
                                Program.MultipleStatement(
                                    Statement.ActionStatement(Action.Forward(nil)),
                                    Program.MultipleStatement(
                                        Statement.ActionStatement(Action.Forward(nil)),
                                        Program.MultipleStatement(
                                            Statement.ActionStatement(Action.RotateRight(nil)),
                                            Program.SingleStatement(
                                                Statement.ActionStatement(Action.Forward(nil))
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

    static let sampleProgram3 = Program.MultipleStatement(
        .LoopStatement(
            .While(
                .Negation(.CompareObservation(.LookForward, MapUnitType.Goal)),
                Program.MultipleStatement(
                    .LoopStatement(
                        .While(
                            .Negation(.CompareObservation(.LookForward, MapUnitType.Wall)),
                            Program.SingleStatement(
                                .ActionStatement(.Forward(nil))
                            )
                        )
                    ),
                    Program.SingleStatement(
                        Statement.ActionStatement(Action.RotateRight(nil))
                    )
                )
            )
        ),
        Program.SingleStatement(
            Statement.ActionStatement(Action.Forward(nil))
        )
    )
}
