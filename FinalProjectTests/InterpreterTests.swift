//
//  InterpreterTests.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 13/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import XCTest
@testable import FinalProject

class InterpreterTests: XCTestCase {
    
    func testSingleActionProgram() {
        let program = Program.SingleStatement(Statement.ActionStatement(Action.Forward))
        let interpreter = Interpreter(program: program)
        let map = Map(numberOfRows: 2, numberOfColumns: 2)
        map.setMapUnitAt(MapUnit.Wall, row: 1, column: 1)
        let agent = DummyAgent()
        var outputActions = [Action]()
        while let action = interpreter.nextAction(map, agent: agent) {
            outputActions.append(action)
        }
        XCTAssertEqual(outputActions, [Action.Forward], "Interpreted actions are not equal!")
    }
    
    func testMultipleActionProgram() {
        let program = Program.MultipleStatement(Statement.ActionStatement(Action.Forward),
            Program.MultipleStatement(Statement.ActionStatement(Action.RotateLeft),
                Program.MultipleStatement(Statement.ActionStatement(Action.Forward),
                    Program.MultipleStatement(Statement.ActionStatement(Action.NoAction), Program.SingleStatement(Statement.ActionStatement(Action.RotateRight))))))
        let interpreter = Interpreter(program: program)
        let map = Map(numberOfRows: 2, numberOfColumns: 2)
        map.setMapUnitAt(MapUnit.Wall, row: 0, column: 1)
        let agent = DummyAgent()
        var outputActions = [Action]()
        while let action = interpreter.nextAction(map, agent: agent) {
            outputActions.append(action)
        }
        XCTAssertEqual(outputActions, [Action.Forward, Action.RotateLeft, Action.Forward, Action.NoAction, Action.RotateRight], "Interpreted actions are not equal!")
    }
    
    func testSimpleConditional() {
        let program = Program.MultipleStatement(Statement.ConditionalStatement(ConditionalExpression.IfThenElseExpression(Predicate.CompareObservation(Observation.LookForward, MapUnit.Wall), Program.SingleStatement(Statement.ActionStatement(Action.RotateRight)), Program.SingleStatement(Statement.ActionStatement(Action.Forward)))), Program.SingleStatement(Statement.ConditionalStatement(ConditionalExpression.IfThenElseExpression(Predicate.CompareObservation(Observation.LookForward, MapUnit.EmptySpace), Program.SingleStatement(Statement.ActionStatement(Action.RotateRight)), Program.SingleStatement(Statement.ActionStatement(Action.Forward))))))
        let interpreter = Interpreter(program: program)
        let map = Map(numberOfRows: 2, numberOfColumns: 2)
        map.setMapUnitAt(MapUnit.Wall, row: 0, column: 1)
        let agent = DummyAgent()
        var outputActions = [Action]()
        while let action = interpreter.nextAction(map, agent: agent) {
            outputActions.append(action)
        }
        XCTAssertEqual(outputActions, [Action.RotateRight, Action.Forward], "Interpreted actions are not equal!")
    }
    
    func testSimpleWhile() {
        let program = Program.MultipleStatement(Statement.LoopStatement(LoopExpression.While(Predicate.CompareObservation(Observation.LookForward, MapUnit.Wall), Program.MultipleStatement(Statement.ActionStatement(Action.RotateLeft), Program.SingleStatement(Statement.ActionStatement(Action.RotateRight))))), Program.SingleStatement(Statement.ActionStatement(Action.Forward)))
        let interpreter = Interpreter(program: program)
        let map1 = Map(numberOfRows: 2, numberOfColumns: 2)
        let map2 = Map(numberOfRows: 2, numberOfColumns: 2)
        map1.setMapUnitAt(MapUnit.Wall, row: 0, column: 1)
        let agent = DummyAgent()
        var outputActions = [Action]()
        for _ in 0..<4 {
            outputActions.append(interpreter.nextAction(map1, agent: agent)!)
        }
        outputActions.append(interpreter.nextAction(map2, agent: agent)!)
        XCTAssertEqual(outputActions, [Action.RotateLeft, Action.RotateRight, Action.RotateLeft, Action.RotateRight, Action.Forward], "Interpreted actions are not equal!")
        
    }
    
    class DummyAgent: AgentProtocol {
        var x = 0
        var y = 0
        var direction = Direction.Down
    }
}
