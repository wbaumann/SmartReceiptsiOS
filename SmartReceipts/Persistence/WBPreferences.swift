//
//  WBPreferences.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/02/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

extension WBPreferences {
    static func prefferedPDFSize() -> PDFPageSize {
        if let index = Int(string: preferedRawPDFSize()) {
            return PDFPageSize.pdfPageSizeBy(index: index)
        }
        return PDFPageSize(rawValue: preferedRawPDFSize())!
    }
    
    static func setPrefferedPDFSize(_ pdfSize: PDFPageSize) {
        setPreferedRawPDFSize(pdfSize.rawValue)
    }
    
    @objc static func isPDFFooterUnlocked() -> Bool {
        return PurchaseService().hasValidSubscriptionValue()
    }
}

enum PDFPageSize: String {
    case A4 = "A4"
    case letter = "Letter"
    
    func size(portrait: Bool) -> CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        switch self {
        case .A4:
            width = 595.0
            height = 842.0
        case .letter:
            width = 612.001
            height = 792.0
        }
        
        return portrait ? CGSize(width: width, height: height) : CGSize(width: height, height: width)
    }
    
    static func pdfPageSizeBy(index: Int) -> PDFPageSize {
        let sizes: [PDFPageSize] = [.A4, .letter]
        return sizes[index]
    }
}
