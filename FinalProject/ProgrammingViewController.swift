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
        } else if let destination = segue.destinationViewController as? PlayingViewController {
            destination.programBlocksToDisplay = programBlocksSupplier.retrieveProgramBlocks()
            destination.map = map
            programBlocksSupplier = nil
            print(navigationController)
            navigationController?.popViewControllerAnimated(false)
        }
    }
}

extension ProgrammingViewController: ProgramBlocksSupplier {
    func retrieveProgramBlocks() -> ProgramBlocks {
        return storedProgramBlocks
    }
}
