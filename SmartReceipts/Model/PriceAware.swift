//
//  PriceAware.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

public protocol PriceAware {
    func createPrice(amount: NSDecimalNumber, currency: WBCurrency) -> Price
}

public extension PriceAware {
    func createPrice(amount: NSDecimalNumber, currency: WBCurrency) -> Price {
        return Price(amount: amount, currencyCode: currency.code())
    }
}