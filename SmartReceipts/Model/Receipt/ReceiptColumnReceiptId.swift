//
//  ReceiptColumnReceiptId.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

class ReceiptColumnReceiptId: ReceiptColumn {
    override func valueFromReceipt(receipt: WBReceipt, forCSV: Bool) -> String {
        return "\(receipt.receiptId())"
    }
}