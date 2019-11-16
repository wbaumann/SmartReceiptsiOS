//
//  UIViewController+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 29/07/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit

protocol Storyboardable: UIViewController {
    static func create() -> Self
    static func create(id: String?) -> Self
}

extension Storyboardable {
    static func create() -> Self {
        return create(id: nil)
    }
    
    static func create(id: String?) -> Self {
        let sb = UIStoryboard(name: String(describing: self), bundle: nil)
        guard let storyboardId = id else { return sb.instantiateInitialViewController() as! Self }
        return sb.instantiateViewController(withIdentifier: storyboardId) as! Self
    }
}
