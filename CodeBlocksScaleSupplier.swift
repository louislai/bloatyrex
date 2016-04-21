//
//  CodeBlocksScaleSupplier.swift
//  BloatyRex
//
//  Created by Tham Zheng Yi on 19/4/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
/// CodeBlocksScaleSupplier protocol allow an object invoking it to
/// return a value denoting the required zoom scale value

import Foundation
import UIKit

protocol CodeBlocksScaleSupplier: class {
    func retrieveScale() -> CGFloat
}
