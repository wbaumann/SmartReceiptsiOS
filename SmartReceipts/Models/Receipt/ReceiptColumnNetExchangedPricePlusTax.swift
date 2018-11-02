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
        let otherCollection = PricesCollection()
        var total = NSDecimalNumber.zero
        let receipts = rows as! [WBReceipt]
        
        for rec in receipts {
            if let exchangedPrice = rec.exchangedPrice() {
                total = total.adding(exchangedPrice.amount)
            } else {
                otherCollection.addPrice(Price(amount: rec.priceAmount, currency: rec.currency))
            }
            
            if WBPreferences.enteredPricePreTax() {
                if let tax = rec.exchangedTax()  {
                    total = total.adding(tax.amount)
                    continue
                } else {
                    if let tax = rec.tax() {
                        otherCollection.addPrice(Price(amount: tax.amount, currency: rec.currency))
                    }
                }
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
