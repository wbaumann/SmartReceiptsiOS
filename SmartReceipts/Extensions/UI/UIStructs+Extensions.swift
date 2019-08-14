//
//  UIStructs+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/08/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation

extension CGRect {
    init(width: CGFloat, height: CGFloat) {
        self = .init(x: 0, y: 0, width: width, height: height)
    }
    
    init(x: CGFloat = 0, y: CGFloat = 0) {
        self = .init(x: x, y: y, width: 0, height: 0)
    }
}
