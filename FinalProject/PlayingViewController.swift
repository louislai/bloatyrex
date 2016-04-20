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
    var levelName: String?
    var packageName: String?

    @IBAction func programmingViewTapped(sender: AnyObject) {
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("ProgrammingViewController")
        let programmingViewController = viewController as! ProgrammingViewController
        programmingViewController.map = map.copy() as! Map
        programmingViewController.storedProgramBlocks = displayedProgramBlocksSupplier.retrieveProgramBlocks()
        scaleToDisplay = codeBlocksDisplay.retrieveScale()
        if let scaleToDisplay = scaleToDisplay {
            programmingViewController.scaleToDisplay = scaleToDisplay
        }
        navigationController?.pushViewController(programmingViewController, animated: false)
        var viewControllersOnStack = (navigationController?.viewControllers)!
        viewControllersOnStack.removeAtIndex(viewControllersOnStack.count - 2)
        navigationController?.viewControllers = viewControllersOnStack
    }

    weak var programSupplier: ProgramSupplier!
    weak var displayedProgramBlocksSupplier: ProgramBlocksSupplier!
    weak var codeBlocksDisplay: CodeBlocksViewController!
    var programBlocksToDisplay: ProgramBlocks?
    @IBOutlet var winningScreen: UIView!
    @IBOutlet var starSlots: [UIImageView]!

    @IBOutlet var firstStar: UIImageView!
    @IBOutlet var secondStar: UIImageView!
    @IBOutlet var thirdStar: UIImageView!
    let animationDelay: NSTimeInterval = 0.5
    var scaleToDisplay: CGFloat?

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
            destination.map = map
            destination.programSupplier = self
        } else if let destination = segue.destinationViewController as? CodeBlocksViewController {
            destination.editEnabled = false
            codeBlocksDisplay = destination
            programSupplier = destination
            displayedProgramBlocksSupplier = destination
            if let programBlocksToDisplay = programBlocksToDisplay {
                destination.programBlocksToLoad = programBlocksToDisplay
            }
            if let scaleToDisplay = scaleToDisplay {
                destination.scaleToDisplay = scaleToDisplay
            }
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
        winningScreen.layer.zPosition = GlobalConstants.zPosition.front
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
}

extension PlayingViewController: ProgramSupplier {
    func retrieveProgram() -> Program? {
        return programSupplier.retrieveProgram()
    }
}
