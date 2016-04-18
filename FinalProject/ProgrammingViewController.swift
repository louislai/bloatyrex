//
//  ProgrammingViewController.swift
//  FinalProject
//
//  Created by louis on 30/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import UIKit

class ProgrammingViewController: UIViewController {
    weak var delegate: FinishedEditingProgramDelegate!
    var map: Map!
    var programBlocksSupplier: ProgramBlocksSupplier!
    var storedProgramBlocks: ProgramBlocks!

    @IBAction func playingViewButtonPressed(sender: AnyObject) {
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("PlayingViewController")
        let playingViewController = viewController as! PlayingViewController
        playingViewController.map = map
        playingViewController.programBlocksToDisplay = programBlocksSupplier.retrieveProgramBlocks()
        navigationController?.pushViewController(playingViewController, animated: false)
        var viewControllersOnStack = (navigationController?.viewControllers)!
        viewControllersOnStack.removeAtIndex(viewControllersOnStack.count - 2)
        navigationController?.viewControllers = viewControllersOnStack
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(navigationController?.viewControllers)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? ThumbnailPlayingMapViewController {
            destination.map = map
        } else if let destination = segue.destinationViewController as? CodeBlocksViewController {
            destination.editEnabled = true
            destination.programBlocksToLoad = storedProgramBlocks
            programBlocksSupplier = destination
        }
    }
}

extension ProgrammingViewController: ProgramBlocksSupplier {
    func retrieveProgramBlocks() -> ProgramBlocks {
        return storedProgramBlocks
    }
}
