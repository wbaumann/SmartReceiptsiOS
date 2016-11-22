//
//  ReceiptColumnExchangeRate.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

class ReceiptColumnExchangeRate: ReceiptColumn {
    override func value(from receipt: WBReceipt, forCSV: Bool) -> String {
        return receipt.exchangeRateAsString()
    }
}
