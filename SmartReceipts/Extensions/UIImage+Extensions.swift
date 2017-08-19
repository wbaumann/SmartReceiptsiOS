//
//  UIImage+Extensions.swift
//  SmartReceipts
//
//  Created by Victor on 1/17/17.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    
    /// Checks if it has any image data:
    /// see http://stackoverflow.com/questions/8180177/uiimage-check-if-contain-image
    public var hasContent: Bool {
        return cgImage != nil || ciImage != nil
    }
    
    func scaledImageSize(_ scale: CGFloat) -> CGSize {
        return CGSize(width: size.width * scale, height: size.height * scale)
    }
}
