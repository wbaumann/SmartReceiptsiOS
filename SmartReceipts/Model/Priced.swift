//
//  Priced.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

protocol Priced {
    var priceAmount: NSDecimalNumber { get }
    var currency: WBCurrency { get }
    
    func price() -> Price
    func priceAsString() -> String
    func formattedPrice() -> String
}