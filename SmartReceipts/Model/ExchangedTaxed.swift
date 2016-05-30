//
//  ExchangedTaxed.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

protocol ExchangedTaxed: Taxed {
    var exchangeRate: NSDecimalNumber? { get }
    var targetCurrency: WBCurrency { get }
    
    func exchangedTax() -> Price?
    func exchangedTaxAsString() -> String
    func formattedExchangedTax() -> String
}