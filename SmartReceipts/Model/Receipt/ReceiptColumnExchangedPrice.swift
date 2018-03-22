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
        let otherCollection = PricesCollection()
        var total = NSDecimalNumber.zero
        let receipts = rows as! [WBReceipt]
        
        for rec in receipts {
            if let exchangedPrice = rec.exchangedPrice() {
                total = total.adding(exchangedPrice.amount)
            } else {
                otherCollection.addPrice(rec.price())
            }
        }
        
        if otherCollection.hasValue() {
            let totalPrice = Price(amount: total, currency: receipts.first!.trip.defaultCurrency)
            return "\(totalPrice.currencyFormattedPrice()); \(otherCollection.currencyFormattedPrice())"
        } else {
            return Price.stringFrom(amount: total)
        }
        
        
    }
}
