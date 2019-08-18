//
//  DecimalFormatter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 02/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

extension NumberFormatter {

    class func formatDouble(_ value: Double, decimalPlaces: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = decimalPlaces
        formatter.roundingIncrement = 0.00000000000000001
        return formatter.string(from: NSNumber(value: value)) ?? "NaN"
    }
    
}

extension NumberFormatter {
    class var exchangeFieldFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 6
        formatter.minimumIntegerDigits = 1
        return formatter
    }
}
