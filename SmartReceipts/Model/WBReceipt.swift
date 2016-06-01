//
//  WBReceipt.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

private let JustDecimalFormatterKey = "JustDecimalFormatterKey"

extension WBReceipt {
    func targetPrice() -> Price {
        if canExchange(), let exchanged = exchangedPrice() {
            return exchanged
        }
        
        return price()
    }
}

extension WBReceipt: Priced {
    func price() -> Price {
        return Price(amount: priceAmount, currency: currency)
    }
    
    func priceAsString() -> String {
        return price().amountAsString()
    }
    
    func formattedPrice() -> String {
        return price().currencyFormattedPrice()
    }
}

extension WBReceipt: Exchanged {
    func exchangeRateAsString() -> String {
        guard let number = exchangeRate where number.compare(NSDecimalNumber.zero()) == .OrderedDescending else {
            return ""
        }
        
        return exchangeRateFormatter().stringFromNumber(number)!
    }
    
    var targetCurrency: WBCurrency {
        return trip.defaultCurrency
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
    
    private func canExchange() -> Bool {
        return targetCurrency != currency
    }
}

extension WBReceipt: ExchangedPriced {
    func exchangedPrice() -> Price? {
        if !canExchange() {
            return nil
        }
        
        guard let rate = exchangeRate where rate.isPositiveAmount() else {
            return nil
        }
        
        let exchangedValue = priceAmount.decimalNumberByMultiplyingBy(rate)
        
        return Price(amount: exchangedValue, currency: targetCurrency)
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
}

extension WBReceipt: Taxed {
    func tax() -> Price? {
        guard let tax = taxAmount where tax.compare(NSDecimalNumber.zero()) != .OrderedSame else {
            return nil
        }
        
        return Price(amount: tax, currency: currency)
    }
    
    func taxAsString() -> String {
        guard let taxValue = tax() else {
            return ""
        }
        
        return taxValue.amountAsString()
    }
    
    func formattedTax() -> String {
        guard let taxValue = tax() else {
            return ""
        }
        
        return taxValue.currencyFormattedPrice()
    }
}

extension WBReceipt: ExchangedTaxed {
    func exchangedTax() -> Price? {
        if !canExchange() {
            return nil
        }

        guard let rate = exchangeRate, tax = taxAmount where rate.isPositiveAmount() && tax.isPositiveAmount() else {
            return nil
        }
        
        let exchangedTax = tax.decimalNumberByMultiplyingBy(rate)
        
        return Price(amount: exchangedTax, currency: targetCurrency)
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

// MARK: - totals
extension WBReceipt {
    func netPrice() -> Price {
        let receiptPrice = price()
        let priceAmount = receiptPrice.amount
        let taxAmount: NSDecimalNumber
        if WBPreferences.enteredPricePreTax() {
            taxAmount = tax()?.amount ?? .zero()
        } else {
            taxAmount = .zero()
        }
        
        let totalAmount = priceAmount.decimalNumberByAdding(taxAmount)
        return Price(amount: totalAmount, currency: receiptPrice.currency)
    }
    
    func netPriceAsString() -> String {
        return netPrice().amountAsString()
    }
    
    func formattedNetPrice() -> String {
        return netPrice().currencyFormattedPrice()
    }

    func exchangedNetPrice() -> Price? {
        if !canExchange() {
            return nil
        }
        
        guard let rate = exchangeRate where rate.isPositiveAmount() else {
            return nil
        }

        let net = netPrice()
        let exchanged = net.amount.decimalNumberByMultiplyingBy(rate)
        return Price(amount: exchanged, currency: targetCurrency)
    }
    
    func exchangedNetPriceAsString() -> String {
        guard let net = exchangedNetPrice() else {
            return ""
        }

        return net.amountAsString()
    }
    
    func formattedExchangedNetPrice() -> String {
        guard let net = exchangedNetPrice() else {
            return ""
        }
        
        return net.currencyFormattedPrice()
    }

}
