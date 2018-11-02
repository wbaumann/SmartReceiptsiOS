//
//  ExchangedTaxed.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

protocol ExchangedTaxed: Taxed, Exchanged {    
    func exchangedTax() -> Price?
    func exchangedTaxAsString() -> String
    func formattedExchangedTax() -> String
}