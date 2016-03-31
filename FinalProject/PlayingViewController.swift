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
    @IBOutlet var winningScreen: UIView!

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

    func notifyGameWon() {
        winningScreen.frame = CGRect(
        x: view.bounds.width,
        y: 0,
        width: winningScreen.bounds.width,
        height: winningScreen.bounds.height
        )
        winningScreen.hidden = false
        winningScreen.backgroundColor = UIColor.cyanColor()
        UIView.animateWithDuration(0.5, animations: { _ in
            self.winningScreen.transform = CGAffineTransformMakeTranslation(-self.winningScreen.bounds.width, 0)
        })
    }
}

extension PlayingViewController: ProgramSupplier {
    func retrieveProgram() -> Program? {
        return programSupplier.retrieveProgram()
    }
}
