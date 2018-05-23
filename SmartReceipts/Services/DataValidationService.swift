//
//  DataValidationService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 28/02/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

class DataValidationService {
    
    func isValidPDF(data: Data) -> Bool {
        guard let dataProvider = CGDataProvider(data: data as CFData) else { return false }
        guard let document = CGPDFDocument(dataProvider) else { return false }
        return document.isEncrypted || !document.isUnlocked ? false : true
    }
    
    func isValidPDF(url: URL) -> Bool {
        if let data = try? Data(contentsOf: url) {
            return isValidPDF(data: data)
        }
        return false
    }
    
    func isValidImage(data: Data) -> Bool {
        return UIImage(data: data) == nil ? false : true
    }
        
    func isValidImage(url: URL) -> Bool {
        if let data = try? Data(contentsOf: url) {
            return isValidImage(data: data)
        }
        return false
    }
            
    
}
