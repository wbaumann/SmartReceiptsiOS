//
//  UIView+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 16/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

extension UIView {
    func layoutIfNeededAnimated(duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration, animations: { self.layoutIfNeeded() })
    }
    
    func layoutSubviewsAnimated(duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration, animations: { self.layoutSubviews() })
    }
}
