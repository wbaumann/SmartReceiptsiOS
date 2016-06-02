//
//  NSNumber+Extensions.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension NSNumber {
    func decimalNumber() -> NSDecimalNumber {
        return NSDecimalNumber(decimal: decimalValue)
    }
}