//
//  TableContentRow.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class TableContentRow: UIView {
    @IBOutlet private(set) var contentLabel: UILabel?
    
    func setValue(_ value: String) {
        if contentLabel == nil {
            contentLabel = subviewLabel()
        }
        contentLabel?.text = value
    }
    
    private func subviewLabel() -> UILabel? {
        for sub in subviews {
            if sub.isKind(of: UILabel.self) {
                return sub as? UILabel
            }
        }
        return nil
    }
    
    func widthFor(value: String) -> CGFloat {
        contentLabel?.lineBreakMode = .byWordWrapping
        contentLabel?.numberOfLines = 0
        contentLabel?.text = value
        let size = CGSize(width: 0, height: CGFloat.greatestFiniteMagnitude)
        let fitSize = contentLabel?.sizeThatFits(size)
        return fitSize!.width + (frame.width - contentLabel!.frame.width)
    }
    
    func heightFor(value: String, width: CGFloat) -> CGFloat {
        contentLabel?.text = value
        let labelWidth = width - (frame.width - contentLabel!.frame.width)
        let size = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        let fitSize = contentLabel?.sizeThatFits(size)
        return fitSize!.height + (frame.height - contentLabel!.frame.height)
    }
}
