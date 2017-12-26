//
//  ReceiptColumnExchangedPriceMinusTax.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class ReceiptColumnExchangedPriceMinusTax: ReceiptColumn {
    
    override func value(from receipt: WBReceipt!, forCSV: Bool) -> String! {
        return Price.stringFrom(amount: receipt.amountMinusTax())
    }
    
    override func value(forFooter rows: [Any]!, forCSV: Bool) -> String! {
        var total = NSDecimalNumber.zero
        for receipt in rows as! [WBReceipt] {
            total = total.adding(receipt.amountMinusTax())
        }
        return Price.stringFrom(amount: total)
    }
}
