//
//  ProgrammingViewController.swift
//  FinalProject
//
//  Created by louis on 30/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import UIKit

class ProgrammingViewController: UIViewController {
    var map: Map!

    @IBAction func zoomButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(false, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? ThumbnailPlayingMapViewController {
            destination.map = map
        }
    }
}
