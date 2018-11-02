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
        if let price = receipt.priceMinusTaxExchanged() {
            return price.amountAsString()
        }
        return LocalizedString("undefined")
    }
    
    override func value(forFooter rows: [Any]!, forCSV: Bool) -> String! {
        let otherCollection = PricesCollection()
        var total = NSDecimalNumber.zero
        let receipts = rows as! [WBReceipt]
        
        for rec in receipts {
            if let exchangedPrice = rec.priceMinusTaxExchanged() {
                total = total.adding(exchangedPrice.amount)
            } else {
                otherCollection.addPrice(rec.priceMinusTax())
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
