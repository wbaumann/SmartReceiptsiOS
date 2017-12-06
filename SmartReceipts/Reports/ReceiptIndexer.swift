//
//  ReceiptIndexer.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class ReceiptIndexer {
    class func indexReceipts(_ receipts: [WBReceipt], filter: (WBReceipt) -> Bool) -> [WBReceipt] {
        var result = [WBReceipt]()
        var i = 1
        for receipt in receipts {
            if filter(receipt) {
                continue
            }
            receipt.reportIndex = i
            result.append(receipt)
            i += 1
        }
        return result
    }
}
