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
        if WBPreferences.enteredPricePreTax() {
            return receipt.price().currencyFormattedPrice()
        }
        let amount = receipt.priceAmount.subtracting(receipt.taxAmount ?? NSDecimalNumber.zero)
        return Price(amount: amount, currency: receipt.price().currency).currencyFormattedPrice()
    }
    
    override func value(forFooter rows: [Any]!, forCSV: Bool) -> String! {
        let collection = PricesCollection()
        for receipt in rows as! [WBReceipt] {
            collection.addPrice(receipt.price())
            if !WBPreferences.enteredPricePreTax() {
                collection.subtractPrice(receipt.tax())
            }
        }
        return collection.currencyFormattedPrice()
    }
    
}
