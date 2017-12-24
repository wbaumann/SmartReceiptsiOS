//
//  ReceiptColumnExchangedPrice.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

class ReceiptColumnExchangedPrice: ReceiptColumn {
    override func value(from receipt: WBReceipt, forCSV: Bool) -> String {
        if forCSV {
            return receipt.exchangedPriceAsString()
        }
        
        return receipt.exchangedPriceAsString()
    }
    
    override func value(forFooter rows: [Any]!, forCSV: Bool) -> String! {
        var total = NSDecimalNumber.zero
        for rec in rows as! [WBReceipt] {
            total = total.adding(rec.exchangedPrice()!.amount)
        }
        return Price.stringFrom(amount: total)
    }
}
