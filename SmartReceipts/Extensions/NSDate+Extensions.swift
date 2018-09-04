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
        formatter.timeZone = TimeZone(identifier: "UTC")
        Thread.cacheObject(formatter, key: DateStringFormatterKey)
        return formatter
    }
    
    func oneYearFromDate() -> Date {
        let gregorian = NSCalendar(calendarIdentifier: .gregorian)!
        var offsetComponents = DateComponents()
        offsetComponents.year = 1
        return gregorian.date(byAdding: offsetComponents, to: self, options: [])!
    }
    
    func daysDifference(date: Date) -> Int {
        let date1 = Calendar.current.startOfDay(for: self)
        let date2 = Calendar.current.startOfDay(for: date)
        let components = Calendar.current.dateComponents([.day], from: date1, to: date2)
        return components.day ?? 0
    }
}
