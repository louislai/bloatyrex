//
//  InterpreterTests.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 13/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import XCTest

class InterpreterTests: XCTestCase {

    func testSingleActionProgram() {
        let program = Program.SingleStatement(Statement.ActionStatement(Action.Forward(nil)))
        let interpreter = Interpreter(program: program)
        let map = Map(numberOfRows: 2, numberOfColumns: 2)
        map.setMapUnitAt(WallNode(), row: 1, column: 1)
        let agent = DummyAgent()
        var outputActions = [Action]()
        while let action = interpreter.nextAction(map, agent: agent) {
            outputActions.append(action)
        }
        print(areEqualActionLists(outputActions, rhs: [Action.Forward(nil)]))
        XCTAssertTrue(areEqualActionLists(outputActions, rhs: [Action.Forward(nil)]))
    }

    func testMultipleActionProgram() {
        let program = Program.MultipleStatement(Statement.ActionStatement(Action.Forward(nil)),
                                                Program.MultipleStatement(Statement.ActionStatement(Action.RotateLeft(nil)),
                                                    Program.MultipleStatement(Statement.ActionStatement(Action.Forward(nil)),
                                                        Program.MultipleStatement(Statement.ActionStatement(Action.NoAction(nil)), Program.SingleStatement(Statement.ActionStatement(Action.RotateRight(nil)))))))
        let interpreter = Interpreter(program: program)
        let map = Map(numberOfRows: 2, numberOfColumns: 2)
        map.setMapUnitAt(WallNode(), row: 0, column: 1)
        let agent = DummyAgent()
        var outputActions = [Action]()
        while let action = interpreter.nextAction(map, agent: agent) {
            outputActions.append(action)
        }
        XCTAssertTrue(areEqualActionLists(outputActions, rhs: [Action.Forward(nil), Action.RotateLeft(nil), Action.Forward(nil), Action.NoAction(nil), Action.RotateRight(nil)]))
    }

    func testSimpleConditional() {
        let program = Program.MultipleStatement(Statement.ConditionalStatement(ConditionalExpression.IfThenElseExpression(Predicate.CompareObservation(Observation.LookForward, MapUnitType.Wall), Program.SingleStatement(Statement.ActionStatement(Action.RotateRight(nil))), Program.SingleStatement(Statement.ActionStatement(Action.Forward(nil))))), Program.SingleStatement(Statement.ConditionalStatement(ConditionalExpression.IfThenElseExpression(Predicate.CompareObservation(Observation.LookForward, MapUnitType.EmptySpace), Program.SingleStatement(Statement.ActionStatement(Action.RotateRight(nil))), Program.SingleStatement(Statement.ActionStatement(Action.Forward(nil)))))))
        let interpreter = Interpreter(program: program)
        let map = Map(numberOfRows: 2, numberOfColumns: 2)
        map.setMapUnitAt(WallNode(), row: 1, column: 0)
        let agent = DummyAgent()
        var outputActions = [Action]()
        while let action = interpreter.nextAction(map, agent: agent) {
            outputActions.append(action)
        }
        XCTAssertTrue(areEqualActionLists(outputActions, rhs: [Action.RotateRight(nil), Action.Forward(nil)]))
    }

    func testSimpleWhile() {
        let program = Program.MultipleStatement(Statement.LoopStatement(LoopExpression.While(Predicate.CompareObservation(Observation.LookForward, MapUnitType.Wall), Program.MultipleStatement(Statement.ActionStatement(Action.RotateLeft(nil)), Program.SingleStatement(Statement.ActionStatement(Action.RotateRight(nil)))))), Program.SingleStatement(Statement.ActionStatement(Action.Forward(nil))))
        let interpreter = Interpreter(program: program)
        let map1 = Map(numberOfRows: 2, numberOfColumns: 2)
        let map2 = Map(numberOfRows: 2, numberOfColumns: 2)
        map1.setMapUnitAt(WallNode(), row: 1, column: 0)
        let agent = DummyAgent()
        var outputActions = [Action]()
        for _ in 0..<4 {
            outputActions.append(interpreter.nextAction(map1, agent: agent)!)
        }
        outputActions.append(interpreter.nextAction(map2, agent: agent)!)
        XCTAssertTrue(areEqualActionLists(outputActions, rhs: [Action.RotateLeft(nil), Action.RotateRight(nil), Action.RotateLeft(nil), Action.RotateRight(nil), Action.Forward(nil)]))
    }

    func testNestedWhile() {
        let program = Program.MultipleStatement(
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

        let interpreter = Interpreter(program: program)
        let map1 = Map(numberOfRows: 2, numberOfColumns: 2)
        let map2 = Map(numberOfRows: 2, numberOfColumns: 2)
        map2.setMapUnitAt(WallNode(), row: 1, column: 0)
        let map3 = Map(numberOfRows: 2, numberOfColumns: 2)
        map3.setMapUnitAt(GoalNode(), row: 1, column: 0)
        let agent = DummyAgent()
        var outputActions = [Action]()
        for _ in 0..<4 {
            outputActions.append(interpreter.nextAction(map1, agent: agent)!)
        }

        for _ in 0..<2 {
            outputActions.append(interpreter.nextAction(map2, agent: agent)!)
        }

        outputActions.append(interpreter.nextAction(map3, agent: agent)!)
        XCTAssertTrue(areEqualActionLists(outputActions, rhs: [Action.Forward(nil), Action.Forward(nil), Action.Forward(nil), Action.Forward(nil), Action.RotateRight(nil), Action.RotateRight(nil), Action.Forward(nil)]))
    }

    class DummyAgent: AgentProtocol {
        var xPosition = 0
        var yPosition = 0
        var direction = Direction.Up
        func isNextStepSafe() -> Bool {
            return false
        }
    }

    private func areEqualActionLists(lhs: [Action], rhs: [Action]) -> Bool {
        if lhs.count != rhs.count {
            return false
        } else {
            for index in 0..<lhs.count {
                if lhs[index] != rhs[index] {
                    return false
                }
            }
            return true
        }
    }
}
