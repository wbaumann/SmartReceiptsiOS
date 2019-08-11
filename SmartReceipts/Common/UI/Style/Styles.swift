//
//  Styles.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/08/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit

// MARK: - View

class ViewStyle: Making {
    var backgroundColor: UIColor = .black
    var cornerRadius: CGFloat = 4
    var shadowColor: UIColor = .black
    var shadowOpacity: Float = 0
    var masksToBounds: Bool = true
    var shadowOffset: CGSize = .zero
    var shadowRadius: CGFloat = 0
    
    static let card = ViewStyle().making {
        $0.backgroundColor = .white
        $0.masksToBounds = false
        $0.shadowOpacity = 0.18
        $0.shadowOffset = .init(width: 0, height: 1)
        $0.shadowRadius = 4
    }
}

// MARK: - Button

class ButtonStyle: ViewStyle {
    var titleColor: UIColor = .white
    var font: UIFont = .systemFont(ofSize: 14)
    var edgeInsets: UIEdgeInsets = .zero
    
    static let main = ButtonStyle().making {
        $0.backgroundColor = AppTheme.primaryColor
        $0.titleColor = .white
        $0.cornerRadius = 5
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.edgeInsets = .init(top: 2, left: 6, bottom: 2, right: 6)
    }
}
