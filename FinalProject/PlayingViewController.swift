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
    @IBOutlet var starSlots: [UIImageView]!

    @IBOutlet var firstStar: UIImageView!
    @IBOutlet var secondStar: UIImageView!
    @IBOutlet var thirdStar: UIImageView!
    let animationDelay: NSTimeInterval = 0.5

    var stars: [UIImageView] {
        return [firstStar, secondStar, thirdStar]
    }

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
            destination.map = mapToPresetMap(map)
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

    func notifyGameWon(notification: NSNotification) {
        winningScreen.frame = CGRect(
            x: view.bounds.width,
            y: 0,
            width: winningScreen.bounds.width,
            height: winningScreen.bounds.height
        )
        winningScreen.hidden = false
        winningScreen.backgroundColor = UIColor.cyanColor()
        UIView.animateWithDuration(0.5, animations: { _ in
            self.winningScreen.frame = CGRect(
                x: self.view.bounds.width-self.winningScreen.bounds.width,
                y: 0,
                width: self.winningScreen.bounds.width,
                height: self.winningScreen.bounds.height
            )
            }, completion: { finished in
//                // Handle rating
                if finished {
                    let isPlayingPresetMap = notification.userInfo![GlobalConstants.Notification.gameWonInfoIsPlayingPresetMap] as! Bool
                    if isPlayingPresetMap {
                        self.showStarSlots()
                        let rating  = notification.userInfo![GlobalConstants.Notification.gameWonInfoRating] as! Int
                        let toAppearStars = self.stars[0..<rating]
                        for (index, star) in toAppearStars.enumerate() {
                            let delay = Int64(index) * Int64(self.animationDelay) * Int64(NSEC_PER_SEC) * 2
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay), dispatch_get_main_queue(), { () -> Void in
                                star.hidden = false
                                UIView.animateWithDuration(self.animationDelay, animations: { Void in
                                    star.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                                })
                                UIView.animateWithDuration(
                                    self.animationDelay,
                                    delay: self.animationDelay / 2.0,
                                    options: UIViewAnimationOptions.CurveEaseIn,
                                    animations: { Void in
                                        star.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 2))
                                    },
                                    completion: nil)
                            })
                        }
                    }
                }
        })

        hideStarSlots()
        hideStars()
    }

    func resetGameScene() {
        UIView.animateWithDuration(0.5, animations: { _ in
            self.winningScreen.frame = CGRect(
                x: self.view.bounds.width,
                y: 0,
                width: self.winningScreen.bounds.width,
                height: self.winningScreen.bounds.height
            )
        })
    }

    @IBAction func backButtonPressed(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func replayButtonTapped(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.Notification.gameReset, object: self)
    }

    @IBAction func nextStageTapped(sender: UIButton) {
    }

    @IBAction func menuButtonTapped(sender: UIButton) {
        navigationController?.popToRootViewControllerAnimated(true)
    }

    private func registerObservers() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(PlayingViewController.notifyGameWon(_:)),
            name: GlobalConstants.Notification.gameWon,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(PlayingViewController.resetGameScene),
            name: GlobalConstants.Notification.gameReset,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector:  #selector(PlayingViewController.resetGameScene),
            name: GlobalConstants.Notification.gameResetAndRun,
            object: nil)
    }

    private func hideStarSlots() {
        let _ = starSlots.map { $0.hidden = true }
    }

    private func showStarSlots() {
        let _ = starSlots.map { $0.hidden = false }
    }

    private func hideStars() {
        let _ = stars.map { $0.hidden = true }
    }

    private func mapToPresetMap(map: Map) -> PresetMap {
        let presetMap = PresetMap(numberOfRows: map.numberOfRows, numberOfColumns: map.numberOfColumns, numberOfStars: 3)
        presetMap.grid = map.grid
        presetMap.assignScoresForRatings([2, 4, 6])
        return presetMap
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
        controller.dismissViewControllerAnimated(true, completion: nil)
        codeBlocksDisplay.scene.setProgramBlocks(programBlocksToDisplay)
    }
}
