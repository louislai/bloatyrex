//
//  File.swift
//  FinalProject
//
//  Created by louis on 16/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// This is main controller responsible for displaying the main game
/// The PlayingViewController contains two containers that segue to 2 child view controllers,
/// PlayingMapViewController to display the game's execution & CodesBlockViewController to
/// display the user's program blocks

import UIKit

class PlayingViewController: UIViewController {
    var map: Map!
    var levelName = GlobalConstants.customLevelName
    var packageName: String?
    var fromProgrammingView = false
    var tutorialImage: UIImage?

    @IBOutlet var tutorialButton: UIButton!
    @IBAction func programmingViewTapped(sender: AnyObject) {
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier(GlobalConstants.Identifier.programmingViewController)
        let programmingViewController = viewController as! ProgrammingViewController
        programmingViewController.map = map.copy() as! Map
        programmingViewController.storedProgramBlocks = displayedProgramBlocksSupplier.retrieveProgramBlocks()
        programmingViewController.levelName = levelName
        programmingViewController.packageName = packageName
        scaleToDisplay = codeBlocksDisplay.retrieveScale()
        programmingViewController.levelName = levelName
        programmingViewController.packageName = packageName
        programmingViewController.tutorialImage = tutorialImage
        if let scaleToDisplay = scaleToDisplay {
            programmingViewController.scaleToDisplay = scaleToDisplay
        }
        navigationController?.replaceViewController(programmingViewController)
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

    @IBOutlet var nextStageButton: UIButton!

    let animationDelay: NSTimeInterval = 0.5
    var scaleToDisplay: CGFloat?

    private var stars: [UIImageView] {
        return [firstStar, secondStar, thirdStar]
    }
    private var nextLevel: String?
    private var nextPackage: String?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerObservers()
        if !fromProgrammingView {
            setupTutorial()
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? PlayingMapViewController {
            destination.map = map
            destination.programSupplier = self
            destination.levelName = levelName
            destination.fromProgrammingView = fromProgrammingView
            if let packageName = packageName {
                destination.levelName = "\(packageName) - \(levelName)"
            }
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
        } else if let destination = segue.destinationViewController as? PlayingHintController {
                destination.tutorialImage = tutorialImage
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

        // Check if user is playing preset map
        hidePresetMapWidgets()
        let isPlayingPresetMap = notification.userInfo![GlobalConstants.Notification.gameWonInfoIsPlayingPresetMap] as! Bool
        if isPlayingPresetMap {
            self.showStarSlots()
            self.showNextStage()
        }

        UIView.animateWithDuration(0.5, animations: { _ in
            self.winningScreen.frame = CGRect(
                x: self.view.bounds.width-self.winningScreen.bounds.width,
                y: 0,
                width: self.winningScreen.bounds.width,
                height: self.winningScreen.bounds.height
            )
            }, completion: { finished in
                // Handle rating
                if finished {
                    if isPlayingPresetMap {
                        let rating  = notification.userInfo![GlobalConstants.Notification.gameWonInfoRating] as! Int
                        let toAppearStars = self.stars[0..<rating]
                        for star in toAppearStars {
                            UIView.animateWithDuration(self.animationDelay, animations: { _ in
                                star.hidden = false
                                star.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                            })
                            UIView.animateWithDuration(
                                self.animationDelay,
                                delay: self.animationDelay / 2.0,
                                options: UIViewAnimationOptions.CurveEaseIn,
                                animations: { Void in
                                    star.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 2))
                                },
                                completion: nil
                            )
                        }
                    }
                }
        })
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

    @IBAction func tutorialButtonPressed(sender: AnyObject) {
        // toggle tutorial visibility
    }

    @IBAction func replayButtonTapped(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.Notification.gameReset, object: self)
    }

    @IBAction func nextStageTapped(sender: UIButton) {
        guard let nextPackage = nextPackage, nextLevel = nextLevel else {
            return
        }
        let newPlayingViewController = storyboard?
            .instantiateViewControllerWithIdentifier(
                GlobalConstants.Identifier.playingViewController
            ) as! PlayingViewController
        let filesArchive = FilesArchive()
        newPlayingViewController.map = filesArchive
            .loadFromPackageFile(
                nextLevel,
                packageName: nextPackage
        )
        newPlayingViewController.packageName = nextPackage
        newPlayingViewController.levelName = nextLevel
        navigationController?.replaceViewController(newPlayingViewController)
    }

    @IBAction func menuButtonTapped(sender: UIButton) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
}

// MARK: Private functions

extension PlayingViewController {
    private func setupTutorial() {
        if let packageName = packageName {
            switch packageName {
            case GlobalConstants.PrepackageNames[0]:
                if GlobalConstants.BasicLevelsWithImages.contains(levelName) {
                    tutorialImage = UIImage(named: "basic-\(levelName)-summary")
                }
            case GlobalConstants.PrepackageNames[1]:
                if GlobalConstants.IfLevelsWithImages.contains(levelName) {
                    tutorialImage = UIImage(named: "if-\(levelName)-summary")
                }
            case GlobalConstants.PrepackageNames[2]:
                if GlobalConstants.IfLevelsWithImages.contains(levelName) {
                    tutorialImage = UIImage(named: "while-\(levelName)-summary")
                }
            default:
                break
            }
        }
        if let _ = tutorialImage {
            performSegueWithIdentifier(GlobalConstants.SegueIdentifier.playingToTutorial, sender: self)
        } else {
            tutorialButton.alpha = 0
        }
    }

    private func showNextStage() {
        retrieveNextStage()
        guard let _ = nextPackage, _ = nextLevel else {
            return
        }
        nextStageButton.hidden = false
    }

    private func retrieveNextStage() {
        guard let packageName = packageName else {
            return
        }
        if let packageIndex = GlobalConstants.PrepackageNames.indexOf(packageName) {
            if let levelIndex = GlobalConstants.PrepackagedLevelsNames[packageIndex].indexOf(levelName) {
                if levelIndex == GlobalConstants.PrepackagedLevelsNames[packageIndex].count-1 {
                    if packageIndex < GlobalConstants.PrepackageNames.count-1 {
                        nextPackage = GlobalConstants.PrepackageNames[packageIndex+1]
                        nextLevel = GlobalConstants.PrepackagedLevelsNames[packageIndex+1][0]
                    }
                } else {
                    nextPackage = packageName
                    nextLevel = GlobalConstants.PrepackagedLevelsNames[packageIndex][levelIndex+1]
                }
            }
        }
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

    private func hidePresetMapWidgets() {
        let _ = starSlots.map { $0.hidden = true }
        let _ = stars.map { $0.hidden = true }
        nextStageButton.hidden = true
    }

    private func showStarSlots() {
        let _ = starSlots.map { $0.hidden = false }
    }
}

// MARK: ProgramSupplier

extension PlayingViewController: ProgramSupplier {
    func retrieveProgram() -> Program? {
        return programSupplier.retrieveProgram()
    }
}
