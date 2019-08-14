//
//  Styles.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/08/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit

// MARK: - View

struct ViewStyle: Making, BaseViewStyle {
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
        $0.shadowOpacity = 1
        $0.shadowOffset = .init(width: 0, height: 16)
        $0.shadowColor = #colorLiteral(red: 0.03921568627, green: 0.003921568627, blue: 0.07843137255, alpha: 0.04)
        $0.shadowRadius = 16
        $0.cornerRadius = 14
    }
}

// MARK: - Button

extension ButtonStyle {
    
    static let main = ButtonStyle().making {
        $0.backgroundColor = .violetAccent
        $0.titleColor = .white
        $0.cornerRadius = 5
        $0.font = .semibold15
        $0.edgeInsets = .init(top: 2, left: 6, bottom: 2, right: 6)
    }
    
    static let mainBig = main.making {
        $0.cornerRadius = 8
    }
    
    static let mainTextOnly = main.making {
        $0.backgroundColor = .clear
        $0.titleColor = .violetAccent
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    
    
}


