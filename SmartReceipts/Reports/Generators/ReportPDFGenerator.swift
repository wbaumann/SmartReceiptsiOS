//
//  ReportPDFGenerator.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class ReportPDFGenerator: ReportGenerator {
    override func receiptColumns() -> [ReceiptColumn] {
        return database.allPDFColumns() as! [ReceiptColumn]
    }
}
