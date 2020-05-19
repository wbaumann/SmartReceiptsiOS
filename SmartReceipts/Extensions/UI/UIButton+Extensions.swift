//
//  UIButton+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12.05.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import UIKit

extension UIButton {
    func set(title: String?, for state: UIButton.State = .normal, animated: Bool = false) {
        if !animated { titleLabel?.text = title }
        setTitle(title, for: state)
    }
}
