//
//  Making.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/08/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit

protocol Making {}

extension Making {
    func making(_ making: (_ style: inout Self) -> Void) -> Self {
        var copy = self
        making(&copy)
        return copy
    }
}

protocol BaseViewStyle {
    var backgroundColor: UIColor { get }
    var cornerRadius: CGFloat { get }
    var shadowColor: UIColor { get }
    var shadowOpacity: Float { get }
    var masksToBounds: Bool { get }
    var shadowOffset: CGSize { get }
    var shadowRadius: CGFloat { get }
}
