//
//  PDFImageView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

private let DEFAULT_COMPRESSION_QUALITY: CGFloat = 0.7

class PDFImageView: UIView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = PDFFontStyle.small.font
    }
    
    func fitImageView() {
        let imageSize = imageView.image!.size
        if imageSize.height > imageSize.width {
            //do nothing for portrait images
            return
        }
        let ratio = imageSize.height/imageSize.width
        let height = imageView.frame.width * ratio
        
        var imageFrame = imageView.frame
        imageFrame.size.height = height
        imageView.frame = imageFrame
    }
    
    func adjustImageSize() {
        let image = imageView.image
        let scaled = WBImageUtils.image(image!, scaledToFit: bounds.size)
        if let scaledAndCompressed = WBImageUtils.compressImage(scaled, withRatio: DEFAULT_COMPRESSION_QUALITY) {
            imageView.image = scaledAndCompressed
            if !scaledAndCompressed.hasContent {
                Logger.error("Actually no image content! Label: \(titleLabel.text ?? "")")
            }
        }
    }
}

