//
//  BorderedLabel.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15/08/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit

class BorderedLabel: UILabel {
    
    var textInsets: UIEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8) {
        didSet { setNeedsDisplay() }
    }
    
    override func drawText(in rect: CGRect) {
        guard text?.isEmpty == false else { super.drawText(in: rect); return }
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var superSize = super.sizeThatFits(size)
        superSize.height += textInsets.top + textInsets.bottom
        superSize.width += textInsets.left + textInsets.right
        return superSize
    }
    
    override var intrinsicContentSize: CGSize {
        guard text?.isEmpty == false else { return super.intrinsicContentSize }

        var size = super.intrinsicContentSize
        size.height += textInsets.top + textInsets.bottom
        size.width += textInsets.left + textInsets.right
        return size
    }
}

