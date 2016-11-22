//
//  NSDecimalNumber+Extensions.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension NSDecimalNumber {
    static func minusOne() -> NSDecimalNumber {
        return NSDecimalNumber(string: "-1")
    }

    func isPositiveAmount() -> Bool {
        return compare(NSDecimalNumber.zero) == .orderedDescending
    }
}
