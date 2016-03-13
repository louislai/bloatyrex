//
//  Interpreter.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 13/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

class Interpreter {
    var program: Program?
    var map: Map
    var agent: AgentProtocol
    
    init(program: Program, map: Map, agent: AgentProtocol) {
        self.program = program
        self.map = map
        self.agent = agent
    }
    
    func nextAction(map: Map, agent: AgentProtocol) -> Action? {
        if let p = program {
            switch p {
            case .SingleStatement(let statement):
                self.program = nil
                return evaluateStatement(statement)
            case .MultipleStatement(let statement, let nextProgram):
                self.program = nextProgram
                return evaluateStatement(statement)
            }
        } else {
            return nil
        }
    }
    
    private func evaluateStatement(statement: Statement) -> Action {
        switch statement {
        case .ActionStatement(let action):
            return action
        case .ConditionalStatement(let conditionalExpression):
            return evaluateConditional(conditionalExpression)
        }
    }
    
    private func evaluateConditional(conditional: ConditionalExpression) -> Action {
        switch conditional {
        case .IfThenElseExpression(let predicate, let thenAction, let elseAction):
            if evaluatePredicate(predicate) {
                return thenAction
            } else {
                return elseAction
            }
        }
    }
    
    private func evaluatePredicate(predicate: Predicate) -> Bool {
        switch predicate {
        case .Conjunction(let left, let right):
            return evaluatePredicate(left) && evaluatePredicate(right)
        case .Disjunction(let left, let right):
            return evaluatePredicate(left) || evaluatePredicate(right)
        case .Negation(let p):
            return !evaluatePredicate(p)
        case .CompareObservation(let observation, let object):
            return observedObject(observation) == object
        }
    }
    
    private func observedObject(observation: Observation) -> MapUnit? {
        switch observation {
        case .LookForward:
            switch agent.direction {
            case .Up:
                return map.retrieveMapUnitAt(agent.x, column: agent.y - 1)
            case .Down:
                return map.retrieveMapUnitAt(agent.x, column: agent.y + 1)
            case .Left:
                return map.retrieveMapUnitAt(agent.x - 1, column: agent.y)
            case .Right:
                return map.retrieveMapUnitAt(agent.x + 1, column: agent.y)
            }
        }
    }
}