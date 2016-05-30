//
//  ReceiptColumnExchangedPrice.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

class ReceiptColumnExchangedPrice: ReceiptColumn {
    override func valueFromReceipt(receipt: WBReceipt, forCSV: Bool) -> String {
        if forCSV {
            return receipt.exchangedPriceAsString()
        }
        
        return receipt.formattedExchangedPrice()
    }
}