//
//  Interpreter+LanguageDelegate.swift
//  FinalProject
//
//  Created by louis on 13/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import Foundation

extension Interpreter: LanguageDelegate {
    func resetInterpreter() {
        self.removeHighlight()
    }
}
