//
//  PricesCollection.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

class PricesCollection: Price {
    private var totals = [String: NSDecimalNumber]()
    
    func addPrice(price: Price?) {
        guard let  price = price else {
            return
        }
        
        add(price.amount, currency: price.currency.code())
    }
    
    func subtractPrice(price: Price?) {
        guard let  price = price else {
            return
        }
        
        add(price.amount.decimalNumberByMultiplyingBy(.minusOne()), currency: price.currency.code())
    }
    
    func hasValue() -> Bool {
        let values = totals.values
        
        for amount in values {
            if amount.compare(NSDecimalNumber.zero()) != .OrderedSame {
                return true
            }
        }
        
        return false
    }
    
    override func currencyFormattedPrice() -> String {
        var formats = [String]()
        let codes = totals.keys.sort()
        for code in codes {
            let amount = totals[code]!
            let price = Price(amount: amount, currencyCode: code)
            formats.append(price.currencyFormattedPrice())
        }
        
        return formats.joinWithSeparator("; ")
    }
    
    private func add(amount: NSDecimalNumber, currency: String) {
        let total = totals[currency] ?? NSDecimalNumber.zero()
        let newTotal = total.decimalNumberByAdding(amount)
        totals[currency] = newTotal
    }
    
    override var hash : Int {
        return currencyFormattedPrice().hash
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let other = object as? PricesCollection {
            return currencyFormattedPrice() == other.currencyFormattedPrice()
        } else {
            return false
        }
    }
}