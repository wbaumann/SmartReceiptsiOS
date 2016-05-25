//
//  Price.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

private let JustDecimalFormatterKey = "JustDecimalFormatterKey"

extension Price {
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