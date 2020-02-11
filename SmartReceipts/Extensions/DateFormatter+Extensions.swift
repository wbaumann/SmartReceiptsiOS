//
//  DateFormatter+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

extension DateFormatter {
    func configure(format: String, timeZone: TimeZone = TimeZone.current) {
        self.timeZone = timeZone
        self.dateFormat = format
    }
    
    func configure(timeZone: TimeZone = TimeZone.current) {
        configure(format: WBPreferences.dateFormat(), timeZone: timeZone)
    }
    
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    
    func addWeekdayFormat() {
        dateFormat = "EEE, " + dateFormat
    }
}
