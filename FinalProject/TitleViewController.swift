//
//  TitleViewController.swift
//  FinalProject
//
//  Created by louis on 16/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {
    var leftRandomTileGenerator: UIView!
    var rightRandomTileGenerator: UIView!
    let upButton = UIImage(named: "up-block")!
    let turnLeftButton = UIImage(named: "turn-left-block")!
    let turnRightButton = UIImage(named: "turn-right-block")!
    let waitButton = UIImage(named: "wait-block")!
    let jumpButton = UIImage(named: "jump-block")!
    let pressRedButton = UIImage(named: "press-red-block")!
    let pressBlueButton = UIImage(named: "press-blue-block")!
    let whileButton = UIImage(named: "while-block")!
    let ifButton = UIImage(named: "if-else-block")!
    let eyesButton = UIImage(named: "eyes")!
    let notButton = UIImage(named: "not-block")!
    let notSafeButton = UIImage(named: "not-safe-block")!
    let toiletButton = UIImage(named: "toilet")!
    let holeButton = UIImage(named: "hole")!
    let wallButton = UIImage(named: "wall")!
    let woodButton = UIImage(named: "wooden-block")!
    let leftCorrectButton = UIImage(named: "buttons-left")!
    let rightCorrectButton = UIImage(named: "buttons-right")!
    let emptySpaceButton = UIImage(named: "space")!
    let monsterButton = UIImage(named: "monster-static")!
    var buttons: [UIImage] {
        return [upButton, turnLeftButton, turnRightButton, waitButton, jumpButton,
                pressRedButton, pressBlueButton, whileButton, ifButton, eyesButton,
                notButton, notSafeButton, toiletButton, holeButton, wallButton,
                woodButton, leftCorrectButton, rightCorrectButton, emptySpaceButton, monsterButton]
    }
    var animator: UIDynamicAnimator? = nil
    let gravity = UIGravityBehavior()
    var timer = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()

        leftRandomTileGenerator = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 500))
        view.addSubview(leftRandomTileGenerator)
        view.sendSubviewToBack(leftRandomTileGenerator)

        rightRandomTileGenerator = UIView(frame: CGRect(x: 824, y: 0, width: 200, height: 500))
        view.addSubview(rightRandomTileGenerator)
        view.sendSubviewToBack(rightRandomTileGenerator)

        animator = UIDynamicAnimator(referenceView: self.view)
        animator?.addBehavior(gravity)

        runRandomTileDrops()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.hidden = true
        automaticallyAdjustsScrollViewInsets = false
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? LevelSelectorPageViewController {
            destination.previousViewController = self
            destination.numberOfItemsPerPage = 15
        }
    }

    func runRandomTileDrops() {
        let randomDelay = Double(arc4random_uniform(200)) / 100
        timer = NSTimer.scheduledTimerWithTimeInterval(randomDelay,
                                               target: self,
                                               selector: #selector(delayedAction),
                                               userInfo: nil,
                                               repeats: false)
    }

    func delayedAction() {
        let isLeft = Int(arc4random_uniform(2)) == 0

        let randomX = Int(arc4random_uniform(250)) - 50
        let randomPosition = CGRect(x: randomX, y: -50, width: 50, height: 50)
        addRandomTile(randomPosition, isLeft: isLeft)
    }

    func addRandomTile(location: CGRect, isLeft: Bool) {
        let newTile = UIImageView(frame: location)
        let randomButtonIndex = Int(arc4random_uniform(UInt32(buttons.count)))
        newTile.image = buttons[randomButtonIndex]

        if isLeft {
            leftRandomTileGenerator.addSubview(newTile)
        } else {
            rightRandomTileGenerator.addSubview(newTile)
        }
        addGravity(newTile)
        runRandomTileDrops()
    }

    func addGravity(tile: UIView) {
        gravity.addItem(tile)
        gravity.gravityDirection = CGVector(dx: 0, dy: 0.8)
    }
}
