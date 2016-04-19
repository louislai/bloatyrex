//
//  Interpreter.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 13/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

class Interpreter {
    var instructions = [Instructions]()
    var programCounter = 0
    var previousAction: Action?

    init(program: Program) {
        self.instructions = compileProgram(program)
        self.instructions.append(.Done)
    }

    func nextAction(map: Map, agent: AgentProtocol) -> Action? {
        if let action = previousAction {
            switch action {
            case .Forward(let block):
                block?.unhighlight()
            case .Jump(let block):
                block?.unhighlight()
            case .RotateLeft(let block):
                block?.unhighlight()
            case .RotateRight(let block):
                block?.unhighlight()
            case .NoAction(let block):
                block?.unhighlight()
            case .ChooseButton(_, let block):
                block?.unhighlight()
            }
        }
        switch instructions[programCounter] {
        case .Done:
            return nil
        case .ActionInstruction(let action):
            programCounter += 1
            previousAction = action
            switch action {
            case .Forward(let block):
                block?.highlight()
            case .Jump(let block):
                block?.highlight()
            case .RotateLeft(let block):
                block?.highlight()
            case .RotateRight(let block):
                block?.highlight()
            case .NoAction(let block):
                block?.highlight()
            case .ChooseButton(_, let block):
                block?.highlight()
            }
            return action
        case .Jump(let displacement):
            programCounter += displacement
            return nextAction(map, agent: agent)
        case .JumpOnFalse(let predicate, let displacement):
            if evaluatePredicate(predicate, map: map, agent: agent) {
                programCounter += 1
                return nextAction(map, agent: agent)
            } else {
                programCounter += displacement
                return nextAction(map, agent: agent)
            }
        }
    }

    private func compileProgram(program: Program?) -> [Instructions] {
        var sourceProgram = program
        var compiledProgram = [Instructions]()
        while let p = sourceProgram {
            switch p {
            case .SingleStatement(let statement):
                sourceProgram = nil
                compiledProgram.appendContentsOf(compileStatement(statement))
            case .MultipleStatement(let statement, let nextProgram):
                sourceProgram = nextProgram
                compiledProgram.appendContentsOf(compileStatement(statement))
            }
        }
        return compiledProgram
    }

    private func compileStatement(statement: Statement) -> [Instructions] {
        var compiledProgram = [Instructions]()
        switch statement {
        case .ActionStatement(let action):
            compiledProgram.append(.ActionInstruction(action))
        case .ConditionalStatement(let conditionalExpression):
            compiledProgram.appendContentsOf(compileConditional(conditionalExpression))
        case .LoopStatement(let loopExpression):
            compiledProgram.appendContentsOf(compileLoop(loopExpression))
        }
        return compiledProgram
    }

    private func compileConditional(conditional: ConditionalExpression) -> [Instructions] {
        var compiledProgram = [Instructions]()
        switch conditional {
        case .IfThenElseExpression(let predicate, let thenProg, let elseProg):
            let thenBody = compileProgram(thenProg)
            let elseBody = compileProgram(elseProg)
            compiledProgram.append(.JumpOnFalse(predicate, thenBody.count + 2))
            compiledProgram.appendContentsOf(thenBody)
            compiledProgram.append(.Jump(elseBody.count + 1))
            compiledProgram.appendContentsOf(elseBody)
        }
        return compiledProgram
    }

    private func compileLoop(loop: LoopExpression) -> [Instructions] {
        var compiledProgram = [Instructions]()
        switch loop {
        case .While(let predicate, let program):
            let loopBody = compileProgram(program)
            compiledProgram.append(.JumpOnFalse(predicate, loopBody.count + 2))
            compiledProgram.appendContentsOf(loopBody)
            compiledProgram.append(.Jump(-(loopBody.count + 1)))
        }
        return compiledProgram
    }

    private func evaluatePredicate(predicate: Predicate, map: Map, agent: AgentProtocol) -> Bool {
        switch predicate {
        case .Conjunction(let left, let right):
            return evaluatePredicate(left, map: map, agent: agent) && evaluatePredicate(right, map: map, agent: agent)
        case .Disjunction(let left, let right):
            return evaluatePredicate(left, map: map, agent: agent) || evaluatePredicate(right, map: map, agent: agent)
        case .Negation(let p):
            return !evaluatePredicate(p, map: map, agent: agent)
        case .CompareObservation(let observation, let object):
            return observedObject(observation, map: map, agent: agent) == object
        case .Safe():
            return agent.isNextStepSafe()
        }
    }

    private func observedObject(observation: Observation, map: Map, agent: AgentProtocol) -> MapUnitType? {
        switch observation {
        case .LookForward:
            switch agent.direction {
            case .Right:
                guard let unit = map.retrieveMapUnitAt(agent.yPosition, column: agent.xPosition + 1) else {
                    return nil
                }
                return unit.type
            case .Left:
                guard let unit = map.retrieveMapUnitAt(agent.yPosition, column: agent.xPosition - 1) else {
                    return nil
                }
                return unit.type
            case .Down:
                guard let unit = map.retrieveMapUnitAt(agent.yPosition - 1, column: agent.xPosition) else {
                    return nil
                }
                return unit.type
            case .Up:
                guard let unit = map.retrieveMapUnitAt(agent.yPosition + 1, column: agent.xPosition) else {
                    return nil
                }
                return unit.type
            }
        }
    }
}
