//
//  Syntax.swift
//  FinalProject
//
//  Created by Koh Wai Kit on 13/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

indirect enum Program {
    case SingleStatement(Statement)
    case MultipleStatement(Statement, Program)
}

enum Statement {
    //Simple action statement
    case ActionStatement(Action)
    //Conditional branching
    case ConditionalStatement(ConditionalExpression)
}

enum ConditionalExpression {
    //If Predicate Then Action Else Action
    case IfThenElseExpression(Predicate, Action, Action)
}

indirect enum Predicate {
    case Negation(Predicate)
    case Conjunction(Predicate, Predicate)
    case Disjunction(Predicate, Predicate)
    case CompareObservation(Observation, MapUnit)
}