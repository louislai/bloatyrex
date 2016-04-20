//
//  PlayingHintController.swift
//  BloatyRex
//
//  Created by louis on 20/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import UIKit

class PlayingHintController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var tutorialImage: UIImage!

    @IBAction func closeButtonTapped(sender: UIButton) {        dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = tutorialImage
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.commonInit()
    }

    private func commonInit() {
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self
    }

}

extension PlayingHintController: UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController,
                                                          presentingViewController presenting: UIViewController,
                                                                                   sourceViewController source: UIViewController) -> UIPresentationController? {

        if presented == self {
            let controller = ModalPresentationController(
                presentedViewController: presented,
                presentingViewController: presenting)
            controller.preferredFrame = CGRect(
                x: 100.0,
                y: 100.0,
                width: 824.0,
                height: 568.0
            )
            return controller
        }
        return nil
    }

    func animationControllerForPresentedController(presented: UIViewController,
                                                   presentingController presenting: UIViewController,
                                                                        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if presented == self {
            return ModalPresentationAnimationController(isPresenting: true)
        } else {
            return nil
        }
    }

    func animationControllerForDismissedController(dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {

            if dismissed == self {
                return ModalPresentationAnimationController(isPresenting: false)
            } else {
                return nil
            }
    }
}
