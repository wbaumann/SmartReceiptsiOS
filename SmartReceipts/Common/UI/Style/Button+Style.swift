//
//  Button+Style.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/08/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit

extension UIButton {
    func apply(style: ButtonStyle) {
        super.apply(style: style)
        
        titleLabel?.font = style.font
        contentEdgeInsets = style.edgeInsets
        setTitleColor(style.titleColor, for: .normal)
    }
}
