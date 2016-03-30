//
//  File.swift
//  FinalProject
//
//  Created by louis on 16/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import UIKit

class PlayingViewController: UIViewController {
    var map: Map!
    var programSupplier: ProgramSupplier!

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? PlayingMapViewController {
            destination.map = map
            destination.programSupplier = self
        } else if let destination = segue.destinationViewController as? CodeBlocksViewController {
            programSupplier = destination
        } else if let destination = segue.destinationViewController as? ProgrammingViewController {
            destination.map = map
        }
    }
}

extension PlayingViewController: ProgramSupplier {
    func retrieveProgram() -> Program? {
        return programSupplier.retrieveProgram()
    }
}
