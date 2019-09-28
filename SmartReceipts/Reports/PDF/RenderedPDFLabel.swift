//
//  RenderedPDFLabel.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit

class RenderedPDFLabel: UILabel {
    
    override var text: String? {
        didSet {
            guard let new = text?.replacingOccurrences(of: NON_BREAKING_SPACE, with: " "), text != new else { return }
            text = new
        }
    }
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        let isPDF = !UIGraphicsGetPDFContextBounds().isEmpty
        if !layer.shouldRasterize && isPDF {
            draw(bounds)
        } else {
            super.draw(layer, in: ctx)
        }
    }
}
