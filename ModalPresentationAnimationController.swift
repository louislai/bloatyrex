//
//  ModalPresentationAnimationController.swift
//  LevelDesigner
//
//  Created by louis on 29/1/16.
//  Copyright © 2016 NUS CS3217. All rights reserved.
// Adapted from https://github.com/PeteC/PresentationControllers

import UIKit

class ModalPresentationAnimationController: NSObject,
    UIViewControllerAnimatedTransitioning {
    private let isPresenting: Bool
    private let duration = 0.5

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext)
        } else {
            animateDismissalWithTransitionContext(transitionContext)
        }
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?)
        -> NSTimeInterval {
        return duration
    }

    // ---- Helper methods

    private func animatePresentationWithTransitionContext(
        transitionContext: UIViewControllerContextTransitioning) {

        guard
            let presentedController =
                transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
                presentedControllerView =
                    transitionContext.viewForKey(UITransitionContextToViewKey),
                containerView = transitionContext.containerView()
            else {
                return
        }

        // Position the presented view off the top of the container view
        presentedControllerView.frame =
            transitionContext.finalFrameForViewController(presentedController)
        presentedControllerView.center.y += containerView.bounds.size.height

        containerView.addSubview(presentedControllerView)

        // Animate the presented view to it's final position
        UIView.animateWithDuration(self.duration, delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.0,
            options: .AllowUserInteraction,
            animations: {
            presentedControllerView.center.y -= containerView.bounds.size.height
            }, completion: {(completed: Bool) in
                transitionContext.completeTransition(completed)
        })
    }

    private func animateDismissalWithTransitionContext(
        transitionContext: UIViewControllerContextTransitioning) {

        guard
            let presentedControllerView =
                transitionContext.viewForKey(UITransitionContextFromViewKey),
                containerView = transitionContext.containerView()
            else {
                return
        }

        // Animate the presented view off the bottom of the view
        UIView.animateWithDuration(self.duration / 2.0,
            delay: 0.0, usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.0,
            options: .AllowUserInteraction,
            animations: {
            presentedControllerView.center.y += containerView.bounds.size.height
            }, completion: {(completed: Bool) in
                transitionContext.completeTransition(completed)
        })
    }
}
