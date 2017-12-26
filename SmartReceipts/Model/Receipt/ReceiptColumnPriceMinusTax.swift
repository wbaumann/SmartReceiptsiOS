//
//  ReceiptColumnPriceMinusTax.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class ReceiptColumnPriceMinusTax : ReceiptColumn {
    
    override func value(from receipt: WBReceipt!, forCSV: Bool) -> String! {
        return receipt.price().currencyFormattedPrice()
    }
    
    override func value(forFooter rows: [Any]!, forCSV: Bool) -> String! {
        let collection = PricesCollection()
        for receipt in rows as! [WBReceipt] {
            collection.addPrice(receipt.price())
        }
        return collection.currencyFormattedPrice()
    }
    
}
