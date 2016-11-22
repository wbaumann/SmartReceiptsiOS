//
//  NSDate+Extensions.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

private let DateStringFormatterKey = "DateStringFormatterKey-yyyy-MM-dd"

extension Date {
    func dayString() -> String {
        return formatter().string(from: self)
    }
    
    fileprivate func formatter() -> DateFormatter {
        if let formatter = Thread.cachedObject(DateFormatter.self, key: DateStringFormatterKey) {
            return formatter
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        Thread.cacheObject(formatter, key: DateStringFormatterKey)
        return formatter
    }
}
