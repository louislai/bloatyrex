//
//  ProgrammingViewController.swift
//  FinalProject
//
//  Created by louis on 30/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// The mother view controller in the programming screen
/// ProgrammingViewController contains 2 containers, one segueing to ThumbnailPlayingViewController
/// and another segueing to CodesBlockViewController
///
/// Public Properties
/// - delegate: FinishedEditingProgramDelegate delegate that will dismiss the view controller
/// - map: a Map object containing the map information
/// - programBlocksSupplier: supplier of the program to the view controller
/// - storedProgramBlocks: the program tree held by the controller
/// - scaleToDisplay: the zoom scale for the view controller

import UIKit

class ProgrammingViewController: UIViewController {
    var map: Map!
    var programBlocksSupplier: ProgramBlocksSupplier!
    var codeBlocksScaleSupplier: CodeBlocksScaleSupplier!
    var storedProgramBlocks: ProgramBlocks!
    var scaleToDisplay: CGFloat?
    var levelName = GlobalConstants.customLevelName
    var packageName: String?

    @IBAction func playingViewButtonPressed(sender: AnyObject) {
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier(GlobalConstants.Identifier.playingViewController)
        let playingViewController = viewController as! PlayingViewController
        playingViewController.map = map
        playingViewController.programBlocksToDisplay = programBlocksSupplier.retrieveProgramBlocks()
        playingViewController.levelName = levelName
        playingViewController.packageName = packageName
        playingViewController.fromProgrammingView = true
        scaleToDisplay = codeBlocksScaleSupplier.retrieveScale()
        if let scaleToDisplay = scaleToDisplay {
            playingViewController.scaleToDisplay = scaleToDisplay
        }
        navigationController?.pushViewController(playingViewController, animated: false)
        var viewControllersOnStack = (navigationController?.viewControllers)!
        viewControllersOnStack.removeAtIndex(viewControllersOnStack.count - 2)
        navigationController?.viewControllers = viewControllersOnStack
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? ThumbnailPlayingMapViewController {
            destination.map = map
            destination.levelName = levelName
            if let packageName = packageName {
                destination.levelName = "\(packageName) - \(levelName)"
            }
        } else if let destination = segue.destinationViewController as? CodeBlocksViewController {
            destination.editEnabled = true
            destination.programBlocksToLoad = storedProgramBlocks
            programBlocksSupplier = destination
            codeBlocksScaleSupplier = destination
            if let scaleToDisplay = scaleToDisplay {
                destination.scaleToDisplay = scaleToDisplay
            }
        }
    }
}

extension ProgrammingViewController: ProgramBlocksSupplier {
    func retrieveProgramBlocks() -> ProgramBlocks {
        return storedProgramBlocks
    }
}
