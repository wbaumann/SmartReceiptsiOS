//
//  PDFPageRenderView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class PDFPageRenderView: UIView {
    var page: CGPDFPage!
    
    override func draw(_ rect: CGRect) {
        backgroundColor = UIColor.white
        
        let format = UIGraphicsImageRendererFormat.default()
        // The problem is that we can't use default CGContext for drawing a pdf on iPhone 7 and newer with iOS10 (extended color devices)
        format.prefersExtendedRange = false
        
        let renderer = UIGraphicsImageRenderer(bounds: rect, format: format)
        
        // Generate UIImage from current PDF page
        let pdfImage = renderer.image { rendererContext in
            WBPdfDrawer.renderPage(page, in: rendererContext as! CGContext, inRectangle: bounds)
        }
        
        // Draw image
        // This method renders within the current context:
        pdfImage.draw(in: rect)
        // so here is another way:
        
        // Clear subviews (just in case, to be sure that pdf wouldn't be rendered twice)
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        // add already rendered PDF file as image
        let imageView = UIImageView(frame: rect)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.white
        imageView.image = pdfImage
        
        addSubview(imageView)
    }
}

