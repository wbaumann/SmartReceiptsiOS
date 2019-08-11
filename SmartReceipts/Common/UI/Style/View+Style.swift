//
//  View+Style.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/08/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit

extension UIView {
    func apply(style: ViewStyle) {
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
        layer.masksToBounds = style.masksToBounds
        layer.shadowColor = style.shadowColor.cgColor
        layer.shadowOpacity = style.shadowOpacity
        layer.shadowOffset = style.shadowOffset
        layer.shadowRadius = style.shadowRadius
    }
}
