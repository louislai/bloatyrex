//
//  Syntax.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 13/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

/// The enums used to represent the language constructs needed. These enums are used to build an
/// Abstract Syntax Tree, which is then parsed by the Interpreter and compiled into instructions
/// for execution.

indirect enum Program {
    case SingleStatement(Statement)
    case MultipleStatement(Statement, Program)
}

indirect enum Statement {
    //Simple action statement
    case ActionStatement(Action)
    //Conditional branching
    case ConditionalStatement(ConditionalExpression)
    case LoopStatement(LoopExpression)
}

enum ConditionalExpression {
    //If Predicate Then Action Else Action
    case IfThenElseExpression(Predicate, Program, Program)
}

enum LoopExpression {
    case While(Predicate, Program)
}

indirect enum Predicate {
    case Negation(Predicate)
    case Conjunction(Predicate, Predicate)
    case Disjunction(Predicate, Predicate)
    case CompareObservation(Observation, MapUnitType)
    case NotSafe()
}

enum Instructions {
    case ActionInstruction(Action)
    case JumpOnFalse(Predicate, Int)
    case Jump(Int)
    case Done
}

enum Construct {
    case None
    case Main
    case ActionConstruct(Action)
    case ConditionalExpressionConstruct(ConditionalExpression)
    case LoopExpressionConstruct(LoopExpression)
    case PredicateConstruct(Predicate)
}
