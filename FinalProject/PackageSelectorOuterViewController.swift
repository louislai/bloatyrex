//
//  PackageSelectorOuterViewController.swift
//  FinalProject
//
//  Created by Tham Zheng Yi on 19/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
//  Displays the entire package selector.
//

import Foundation
import UIKit

class PackageSelectorOuterViewController: UIViewController {

    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
