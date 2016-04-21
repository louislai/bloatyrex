//
//  NavigationControllerUtils.swift
//  BloatyRex
//
//  Created by louis on 19/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// Utility extension for UINavigationController

import UIKit

extension UINavigationController {
    func replaceViewController(viewController: UIViewController) {
        pushViewController(viewController, animated: false)
        guard viewControllers.count > 1 else {
            return
        }
        viewControllers.removeAtIndex(viewControllers.count - 2)
    }
}
