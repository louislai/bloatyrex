//
//  TitleViewController.swift
//  FinalProject
//
//  Created by louis on 16/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
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
}
