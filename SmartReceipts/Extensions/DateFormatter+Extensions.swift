//
//  DateFormatter+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

extension DateFormatter {
    func configure(separator: String, timeZone: TimeZone = TimeZone.current) {
        var template = DateFormatter.dateFormat(fromTemplate: "MMddyyyy", options: 0, locale: NSLocale.current)
        template = template?.replacingOccurrences(of: "/", with: separator)
        template = template?.replacingOccurrences(of: ".", with: separator)
        template = template?.replacingOccurrences(of: "-", with: separator)
        self.timeZone = timeZone
        dateFormat = template
    }
    
    func configure(timeZone: TimeZone = TimeZone.current) {
        configure(separator: WBPreferences.dateSeparator(), timeZone: timeZone)
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
