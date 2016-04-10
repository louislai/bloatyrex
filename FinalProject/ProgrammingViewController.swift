//
//  ProgrammingViewController.swift
//  FinalProject
//
//  Created by louis on 30/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import UIKit

class ProgrammingViewController: UIViewController {
    var map: Map!
    var programSupplier: ProgramSupplier!
    var storedProgram: Program!

    @IBAction func zoomButtonPressed(sender: UIButton) {
        storedProgram = programSupplier.retrieveProgram()
        programSupplier = nil
        dismissViewControllerAnimated(false, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? ThumbnailPlayingMapViewController {
            destination.map = map
        } else if let destination = segue.destinationViewController as? CodeBlocksViewController {
            programSupplier = destination
        }
    }
}

extension ProgrammingViewController: ProgramSupplier {
    func retrieveProgram() -> Program? {
        return storedProgram
    }
}