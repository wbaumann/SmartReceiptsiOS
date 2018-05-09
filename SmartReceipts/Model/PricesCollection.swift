//
//  PricesCollection.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

class PricesCollection: Price {
    fileprivate var totals = [String: NSDecimalNumber]()
    
    func addPrice(_ price: Price?) {
        guard let  price = price else {
            return
        }
        
        add(price.amount, currency: price.currency.code)
    }
    
    func subtractPrice(_ price: Price?) {
        guard let  price = price else {
            return
        }
        
        add(price.amount.multiplying(by: .minusOne()), currency: price.currency.code)
    }
    
    func hasValue() -> Bool {
        let values = totals.values
        
        for amount in values {
            if amount.compare(NSDecimalNumber.zero) != .orderedSame {
                return true
            }
        }
        
        return false
    }
    
    override func currencyFormattedPrice() -> String {
        return currencyFormattedTotalPrice(ignoreEmpty: true)
    }
    
    func currencyFormattedTotalPrice(ignoreEmpty: Bool = true) -> String {
        var formats = [String]()
        let codes = totals.keys.sorted()
        for code in codes {
            let amount = totals[code]!
            if ignoreEmpty && amount.decimalValue == 0 { continue }
            
            let price = Price(amount: amount, currencyCode: code)
            formats.append(price.currencyFormattedPrice())
        }
        
        return formats.joined(separator: "; ")
    }
    
    func formattedCurrencies() -> String {
        let codes = totals.keys.sorted()
        return codes.joined(separator: "; ")
    }
    
    fileprivate func add(_ amount: NSDecimalNumber, currency: String) {
        let total = totals[currency] ?? NSDecimalNumber.zero
        let newTotal = total.adding(amount)
        totals[currency] = newTotal
    }
    
    override var hash : Int {
        return currencyFormattedPrice().hash
    }
    
    override func copy() -> Any {
        let copy = PricesCollection()
        for (currency, amount) in totals {
            copy.add(amount, currency: currency)
        }
        return copy
    }
    
    static func + (left: PricesCollection, right: PricesCollection) -> PricesCollection {
        let newPricesCollection = left.copy() as! PricesCollection
        for (currency, amount) in right.totals {
            newPricesCollection.add(amount, currency: currency)
        }
        return newPricesCollection
    }
    
    static func += (left: PricesCollection, right: PricesCollection) {
        for (currency, amount) in right.totals {
            left.add(amount, currency: currency)
        }
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? PricesCollection {
            return currencyFormattedPrice() == other.currencyFormattedPrice()
        } else {
            return false
        }
    }
}
