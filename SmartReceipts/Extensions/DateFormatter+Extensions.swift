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
}
