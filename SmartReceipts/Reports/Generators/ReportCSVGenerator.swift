//
//  ReportCSVGenerator.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

class ReportCSVGenerator: ReportGenerator {
    override func receiptColumns() -> [ReceiptColumn] {
        return database.allCSVColumns() as! [ReceiptColumn]
    }
}
