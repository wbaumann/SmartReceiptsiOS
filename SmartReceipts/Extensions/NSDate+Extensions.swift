//
//  NSDate+Extensions.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

private let DateStringFormatterKey = "DateStringFormatterKey-yyyy-MM-dd"

extension NSDate {
    func dayString() -> String {
        return formatter().stringFromDate(self)
    }
    
    private func formatter() -> NSDateFormatter {
        if let formatter = NSThread.cachedObject(NSDateFormatter.self, key: DateStringFormatterKey) {
            return formatter
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        NSThread.cacheObject(formatter, key: DateStringFormatterKey)
        return formatter
    }
}