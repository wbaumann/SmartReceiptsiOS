//
//  PDFPageRenderView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class PDFPageRenderView: UIView {
    
    func render(page: CGPDFPage) {
        for subview in subviews { subview.removeFromSuperview() }
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.white
        autoreleasepool {
            let pageRect = page.getBoxRect(.mediaBox)
            let format = UIGraphicsImageRendererFormat.default()
            format.prefersExtendedRange = false
            let renderer = UIGraphicsImageRenderer(bounds: pageRect, format: format)
            let data =  renderer.jpegData(withCompressionQuality: kImageCompression, actions: { cnv in
                UIColor.white.set()
                cnv.fill(pageRect)
                cnv.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
                cnv.cgContext.scaleBy(x: 1.0, y: -1.0)
                cnv.cgContext.drawPDFPage(page)
            })
            imageView.image = UIImage(data: data)
        }
        addSubview(imageView)
    }
}

