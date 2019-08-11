//
//  UIViewController+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 29/07/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit

protocol Storyboardable: class {
    static func create() -> Self
}

extension Storyboardable {
    static func create() -> Self {
        let storyboard = UIStoryboard(name: "\(self)", bundle: nil)
        return storyboard.instantiateInitialViewController() as! Self
    }
}
