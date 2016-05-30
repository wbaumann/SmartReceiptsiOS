//
//  ExchangedPriced.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

protocol ExchangedPriced: Priced {
    var exchangeRate: NSDecimalNumber? { get }
    var targetCurrency: WBCurrency { get }
    
    func exchangedPrice() -> Price?
    func exchangedPriceAsString() -> String
    func formattedExchangedPrice() -> String
}