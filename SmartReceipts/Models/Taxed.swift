//
//  Taxed.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

protocol Taxed {
    var taxAmount: NSDecimalNumber? { get }
    var currency: Currency { get }

    func tax() -> Price?
    func taxAsString() -> String
    func formattedTax() -> String
}
