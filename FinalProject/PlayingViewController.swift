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
    var displayedProgramBlocksSupplier: ProgramBlocksSupplier!
    var codeBlocksDisplay: CodeBlocksViewController!
    @IBOutlet var winningScreen: UIView!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerObservers()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? PlayingMapViewController {
            destination.map = map
            destination.programSupplier = self
        } else if let destination = segue.destinationViewController as? CodeBlocksViewController {
            destination.editEnabled = false
            codeBlocksDisplay = destination
            programSupplier = destination
            displayedProgramBlocksSupplier = destination
        } else if let destination = segue.destinationViewController as? ProgrammingViewController {
            destination.delegate = self
            destination.map = map.copy() as! Map
            destination.storedProgramBlocks = displayedProgramBlocksSupplier.retrieveProgramBlocks()
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

    func resetGameScene() {
        UIView.animateWithDuration(0.5, animations: { _ in
            self.winningScreen.transform = CGAffineTransformMakeTranslation(self.winningScreen.bounds.width, 0)
        })
    }

    @IBAction func backButtonPressed(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }

    private func registerObservers() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(PlayingViewController.notifyGameWon),
            name: GlobalConstants.Notification.gameWon,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(PlayingViewController.resetGameScene),
            name: GlobalConstants.Notification.gameReset,
            object: nil)
    }
}

extension PlayingViewController: ProgramSupplier {
    func retrieveProgram() -> Program? {
        return programSupplier.retrieveProgram()
    }
}

// MARK: - FinishedEditingProgramDelegate
extension PlayingViewController:FinishedEditingProgramDelegate {
    func finishedEditing(controller: ProgrammingViewController) {
        let programBlocksToDisplay = controller.storedProgramBlocks
        programBlocksToDisplay.hideTrash()
        controller.dismissViewControllerAnimated(true, completion: nil)
        codeBlocksDisplay.scene.setProgramBlocks(programBlocksToDisplay)
    }
}
