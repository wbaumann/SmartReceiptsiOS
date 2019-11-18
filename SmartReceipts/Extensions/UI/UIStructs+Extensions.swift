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

extension UIColor {
    class var srBlack: UIColor      { return #colorLiteral(red: 0.03921568627, green: 0.003921568627, blue: 0.07843137255, alpha: 1) }
    class var srLightGray: UIColor  { return #colorLiteral(red: 0.9529411765, green: 0.9490196078, blue: 0.9725490196, alpha: 1) }
    class var srRed: UIColor        { return #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1) }
    class var srViolet: UIColor     { return #colorLiteral(red: 0.2705882353, green: 0.1568627451, blue: 0.6235294118, alpha: 1) }
    class var srViolet2: UIColor    { return #colorLiteral(red: 0.1882352941, green: 0.1058823529, blue: 0.5725490196, alpha: 1) }
}
