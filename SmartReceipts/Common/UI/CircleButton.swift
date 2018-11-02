//
//  CircleButton.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 19/08/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit

@IBDesignable
class CircleButton: UIButton {
    
    @IBInspectable var shadowOffset: CGSize  = CGSize(width: 1, height: 1)
    @IBInspectable var shadowRadius: CGFloat = 2
    @IBInspectable var shadowColor: UIColor  = UIColor.black
    @IBInspectable var shadowOpacity: Float  = 0.4
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyLayer()
    }
    
    override func prepareForInterfaceBuilder() {
        applyLayer()
    }
    
    private func applyLayer() {
        layer.cornerRadius  = bounds.width/2.0
        layer.shadowOffset  = shadowOffset
        layer.shadowRadius  = shadowRadius
        layer.shadowColor   = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
    }
}
