//
//  ReceiptColumnPrice.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

class ReceiptColumnPrice: ReceiptColumn {
    override func value(from receipt: WBReceipt, forCSV: Bool) -> String {
        return receipt.priceAsString()
    }
    
    override func value(forFooter rows: [Any]!, forCSV: Bool) -> String! {
        var total = NSDecimalNumber.zero
        for rec in rows as! [WBReceipt] {
            guard let priceToAdd = rec.exchangedPrice() else { continue }
            total = total.adding(priceToAdd.amount)
        }
        return Price.stringFrom(amount: total)
    }
}
