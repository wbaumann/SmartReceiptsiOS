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


struct ButtonStyle: Making, BaseViewStyle {
    var backgroundColor: UIColor = .black
    var cornerRadius: CGFloat = 4
    var shadowColor: UIColor = .black
    var shadowOpacity: Float = 0
    var masksToBounds: Bool = true
    var shadowOffset: CGSize = .zero
    var shadowRadius: CGFloat = 0
    
    var titleColor: UIColor = .white
    var font: UIFont = .systemFont(ofSize: 14)
    var edgeInsets: UIEdgeInsets = .zero
}
