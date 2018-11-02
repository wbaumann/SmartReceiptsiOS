//
//  Price.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

@objcMembers
class Price: NSObject {
    private(set) var amount: NSDecimalNumber!
    private(set) var currency: Currency!
    
    init(amount: NSDecimalNumber, currencyCode: String) {
        self.amount = amount
        self.currency = Currency.currency(forCode: currencyCode)
    }
    
    init(amount: NSDecimalNumber, currency: Currency) {
        self.amount = amount
        self.currency = currency
    }
    
    init(currencyCode: String) {
        self.amount = NSDecimalNumber.zero
        self.currency = Currency.currency(forCode: currencyCode)
    }
    
    override init() {
        super.init()
        amount = NSDecimalNumber.zero
        currency = Currency.currency(forCode: WBPreferences.defaultCurrency())
    }
    
    func currencyFormattedPrice() -> String {
        return Price.formatterForCurrency(code: currency.code).string(from: amount)!
    }
    
    func mileageRateCurrencyFormattedPrice() -> String {
        let locale = Locale.current as NSLocale
        let amount = Price.mileageRateStringFrom(amount: self.amount)
        let currencySymbol = locale.displayName(forKey: NSLocale.Key.currencySymbol, value: currency.code) ?? ""
        return "\(currencySymbol)\(amount)"
    }
    
    func amountAsString() -> String {
        return Price.stringFrom(amount: amount)
    }
    
    func mileageRateAmountAsString() -> String {
        return Price.mileageRateStringFrom(amount: amount)
    }
    
    class func stringFrom(amount: NSDecimalNumber) -> String {
        let noCurrencyKey = "noCurrencyFormatter"
        var noCurrencyFormatter = Thread.current.threadDictionary[noCurrencyKey] as? NumberFormatter
        if noCurrencyFormatter == nil {
            noCurrencyFormatter = NumberFormatter()
            noCurrencyFormatter?.numberStyle = .decimal
            noCurrencyFormatter?.maximumFractionDigits = 2
            noCurrencyFormatter?.minimumFractionDigits = 2
            noCurrencyFormatter?.usesGroupingSeparator = false
            Thread.current.threadDictionary[noCurrencyKey] = noCurrencyFormatter
        }
        return (noCurrencyFormatter!.string(from: amount)! as NSString).trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    class func mileageRateStringFrom(amount: NSDecimalNumber) -> String {
        let noCurrencyRateKey = "noCurrencyRateFormatter"
        var noCurrencyRateFormatter = Thread.current.threadDictionary[noCurrencyRateKey] as? NumberFormatter
        if noCurrencyRateFormatter == nil {
            noCurrencyRateFormatter = NumberFormatter()
            noCurrencyRateFormatter?.numberStyle = .decimal
            noCurrencyRateFormatter?.maximumFractionDigits = 2
            noCurrencyRateFormatter?.minimumFractionDigits = 3
            noCurrencyRateFormatter?.usesGroupingSeparator = false
            Thread.current.threadDictionary[noCurrencyRateKey] = noCurrencyRateFormatter
        }
        return (noCurrencyRateFormatter!.string(from: amount)! as NSString).trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    class func formatterForCurrency(code: String) -> NumberFormatter {
        var formatter = Thread.current.threadDictionary[code] as? NumberFormatter
        if formatter == nil {
            formatter = NumberFormatter()
            formatter?.numberStyle = .currency
            formatter?.maximumFractionDigits = 2
            formatter?.minimumFractionDigits = 2
            formatter?.currencyCode = code
            Thread.current.threadDictionary[code] = formatter
        }
        return formatter!
    }
}
