//
//  PDFPageView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 04/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

fileprivate let ElementsSpacing: CGFloat = 16

class PDFPageView: UIView {
    
    @IBOutlet private weak var topLine: UIView!
    @IBOutlet private weak var bottomLine: UIView!
    @IBOutlet private weak var footerLabel: UILabel!
    private var contentOffset: CGFloat!
    var imageIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topLine.backgroundColor = AppTheme.reportPDFStyleColor
        bottomLine.backgroundColor = AppTheme.reportPDFStyleColor
        
        contentOffset = topLine.frame.origin.y + topLine.frame.height + ElementsSpacing
        footerLabel.font = PDFFontStyle.footer.font
        
        footerLabel.text = WBPreferences.isPDFFooterUnlocked()
            ? WBPreferences.pdfFooterString()
            : LocalizedString("pref_pro_pdf_footer_ios_defaultValue")
    }
    
    var contentWidth: CGFloat { return topLine.bounds.width }
    
    func appendHeader(_ header: TripReportHeader) {
        var newFrame = header.frame
        newFrame.size.width = topLine.frame.width
        header.frame = newFrame
        header.layoutIfNeeded()
        appendElement(header)
    }
    
    func appendTable(_ table: PDFReportTable) {
        appendElement(table)
    }
    
    func appendImage(_ imageView: PDFImageView) {
        var origin = CGPoint.zero
        
        let topLineBottom = topLine.frame.origin.y + topLine.frame.height
        if imageIndex == 0 {
            origin = CGPoint(x: topLine.frame.minX, y: topLineBottom + ElementsSpacing)
        } else if imageIndex == 1 {
            origin = CGPoint(x: (bounds.width + ElementsSpacing)/2, y: topLineBottom + ElementsSpacing)
        } else if imageIndex == 2 {
            origin = CGPoint(x: topLine.frame.minX, y: (self.frame.height + ElementsSpacing)/2)
        } else {
            origin = CGPoint(x: (bounds.width + ElementsSpacing)/2, y: (self.frame.height + ElementsSpacing)/2)
        }
        
        var frame = imageView.frame
        frame.origin = origin
        imageView.frame = frame
        addSubview(imageView)
        
        imageView.adjustImageSize()
        imageIndex += 1
    }
    
    func remainingSpace() -> CGFloat {
        return bottomLine.frame.origin.y - ElementsSpacing - contentOffset
    }
    
    func isEmpty() -> Bool {
        return (contentOffset <= topLine.frame.origin.y + topLine.frame.height + ElementsSpacing) && imageIndex == 0
    }
    
    func appendFullPageElement(_ element: UIView) {
        appendElement(element)
    }
    
    private func appendElement(_ element: UIView) {
        var frame = element.frame
        frame.origin.x = (self.frame.width - frame.width)/2
        frame.origin.y = contentOffset
        element.frame = frame
        addSubview(element)
        
        contentOffset += frame.height + ElementsSpacing
    }
    
}

