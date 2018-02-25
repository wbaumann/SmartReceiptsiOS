//
//  WBPreferences.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/02/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

extension WBPreferences {
    static func prefferedPDFSize() -> PDFPageSize {
        return PDFPageSize(rawValue: preferedRawPDFSize())!
    }
    
    static func setPrefferedPDFSize(_ pdfSize: PDFPageSize) {
        setPreferedRawPDFSize(pdfSize.rawValue)
    }
}

enum PDFPageSize: Int {
    case A4 = 0
    case letter = 1
    
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
    
}
