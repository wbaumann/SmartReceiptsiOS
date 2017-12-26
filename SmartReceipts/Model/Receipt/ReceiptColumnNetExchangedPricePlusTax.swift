//
//  ReceiptColumnNetExchangedPricePlusTax.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

class ReceiptColumnNetExchangedPricePlusTax: ReceiptColumn {
    override func value(from receipt: WBReceipt, forCSV: Bool) -> String {
        return receipt.exchangedNetPriceAsString()
    }
    
    override func value(forFooter rows: [Any]!, forCSV: Bool) -> String! {
        var total = NSDecimalNumber.zero
        for rec in rows as! [WBReceipt] {
            total = total.adding(rec.exchangedPrice()!.amount)
            if WBPreferences.enteredPricePreTax() {
                total = total.adding(rec.exchangedTax()!.amount)
            }
        }
        return Price.stringFrom(amount: total)
    }
}
