//
//  WBReceipt.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

private let JustDecimalFormatterKey = "JustDecimalFormatterKey"

extension WBReceipt: Priced, PriceAware {
    func price() -> Price {
        return createPrice(priceAmount, currency: currency)
    }
    
    func priceAsString() -> String {
        return ""
    }
    
    func formattedPrice() -> String {
        return ""
    }

    func exchangeRateAsString() -> String {
        guard let number = exchangeRate where number.compare(NSDecimalNumber.zero()) == .OrderedDescending else {
            return ""
        }
        
        return exchangeRateFormatter().stringFromNumber(number)!
    }
    
    private func exchangeRateFormatter() -> NSNumberFormatter {
        if let formatter = NSThread.cachedObject(NSNumberFormatter.self, key: JustDecimalFormatterKey) {
            return formatter
        }
        
        let formatter = NSNumberFormatter()
        formatter.maximumFractionDigits = SmartReceiptExchangeRateDecimalPlaces
        formatter.minimumIntegerDigits = 1
        NSThread.cacheObject(formatter, key: JustDecimalFormatterKey)
        return formatter
    }
}

extension WBReceipt: ExchangedPriced {
    func exchangedPrice() -> Price? {
        guard let rate = exchangeRate where rate.isPositiveAmount() else {
            return nil
        }
        
        let exchangedValue = priceAmount.decimalNumberByMultiplyingBy(rate)
        
        return createPrice(exchangedValue, currency: targetCurrency)
    }
    
    func exchangedPriceAsString() -> String {
        guard let exchanged = exchangedPrice() else {
            return ""
        }
        
        return exchanged.amountAsString()
    }
    
    func formattedExchangedPrice() -> String {
        guard let exchanged = exchangedPrice() else {
            return ""
        }
        
        return exchanged.currencyFormattedPrice()
    }
    
    var targetCurrency: WBCurrency {
        return trip.defaultCurrency
    }
}

extension WBReceipt: Taxed {
    func tax() -> Price? {
        guard let tax = taxAmount else {
            return nil
        }
        
        return createPrice(tax, currency: currency)
    }
    
    func taxAsString() -> String {
        return ""
    }
    
    func formattedTax() -> String {
        return ""
    }
}

extension WBReceipt: ExchangedTaxed {
    func exchangedTax() -> Price? {
        guard let rate = exchangeRate, tax = taxAmount where rate.isPositiveAmount() && tax.isPositiveAmount() else {
            return nil
        }
        
        let exchangedTax = tax.decimalNumberByMultiplyingBy(rate)
        
        return createPrice(exchangedTax, currency: targetCurrency)
    }
    
    func exchangedTaxAsString() -> String {
        guard let tax = exchangedTax() else {
            return ""
        }
        
        return tax.amountAsString()
    }
    
    func formattedExchangedTax() -> String {
        guard let tax = exchangedTax() else {
            return ""
        }
        
        return tax.currencyFormattedPrice()
    }
}
