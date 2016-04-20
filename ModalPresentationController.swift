//
//  DesignViewController+UIPresentationController.swift
//  LevelDesigner
//
//  Created by louis on 29/1/16.
//  Copyright © 2016 NUS CS3217. All rights reserved.
// Adapted from https://github.com/PeteC/PresentationControllers
// /blob/master/App/PresentationControllers/CustomPresentationController.swift

import UIKit

class ModalPresentationController: UIPresentationController {
    var preferredFrame: CGRect?

    private lazy var dimmingView: UIView = {
        let view = UIView(frame: self.containerView!.bounds)
        view.alpha = 0.0
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        return view
    }()

    override func presentationTransitionWillBegin() {
        guard
            let containerView = containerView,
                presentedView = presentedView()
            else {
                return
        }

        // Add the dimming view and the presented view to the hierarchy
        dimmingView.frame = containerView.bounds
        containerView.addSubview(dimmingView)
        containerView.addSubview(presentedView)

        // Fade in the dimming view alongside the transition
        let transitionCoordinator = presentingViewController.transitionCoordinator()
        transitionCoordinator!
            .animateAlongsideTransition({ _ in
            self.dimmingView.alpha  = 1.0
            }, completion: nil)
    }

    override func presentationTransitionDidEnd(completed: Bool) {
        // If the presentation didn't complete, remove the dimming view
        if !completed {
            self.dimmingView.removeFromSuperview()
        }
    }

    override func dismissalTransitionWillBegin() {
        // Fade out the dimming view alongside the transition
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator() {
            transitionCoordinator
                .animateAlongsideTransition({ _ in
                        self.dimmingView.alpha = 1.0
                }, completion: nil)
        }
    }

    override func dismissalTransitionDidEnd(completed: Bool) {
        // If the dismissal completed, remove the dimming view
        if completed {
            self.dimmingView.removeFromSuperview()
        }
    }

    override func frameOfPresentedViewInContainerView() -> CGRect {
        if let frame = preferredFrame {
            return frame
        }
        // Inset the presented view's frame
        var frame = containerView!.bounds
//        frame = CGRectInset(frame, 100.0, 100.0)
        return frame
    }
}
