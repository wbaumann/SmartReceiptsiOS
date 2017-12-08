//
//  ReceiptColumnExchangedTax.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

class ReceiptColumnExchangedTax: ReceiptColumn {
    override func value(from receipt: WBReceipt, forCSV: Bool) -> String {
        if forCSV {
            return receipt.exchangedTaxAsString()
        }
        
        return receipt.exchangedTaxAsString()
    }
}
