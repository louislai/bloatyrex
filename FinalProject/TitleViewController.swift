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
    let poop = UIImage(named: "poo")!
    var poopView: UIImageView!
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
        let randomDelay = Double(arc4random_uniform(150)) / 100
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
        poopView = UIImageView(frame: location)
        poopView.image = poop

        if isLeft {
            leftRandomTileGenerator.addSubview(poopView)
        } else {
            rightRandomTileGenerator.addSubview(poopView)
        }
        addGravity(poopView)
        runRandomTileDrops()
    }

    func addGravity(tile: UIView) {
        gravity.addItem(tile)
        gravity.gravityDirection = CGVector(dx: 0, dy: 0.8)
    }
}
