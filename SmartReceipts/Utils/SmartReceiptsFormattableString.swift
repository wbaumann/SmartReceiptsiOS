//
//  SmartReceiptsFormattableString.swift
//  SmartReceipts
//
//  Created by William Baumann on 7/1/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

class SmartReceiptsFormattableString : NSObject {
    
    private static let ReportName = "%REPORT_NAME%";
    private static let UserId = "%USER_ID%";
    private static let ReportStart = "%REPORT_START%";
    private static let ReportEnd = "%REPORT_END%";
    
    private let originalText: String
    private let dateFormatter: WBDateFormatter
    
    init(fromOriginalText originalText: String) {
        self.originalText = originalText
        self.dateFormatter = WBDateFormatter();
    }
    
    func format(trip: WBTrip) -> String {
        return self.originalText
            .stringByReplacingOccurrencesOfString(SmartReceiptsFormattableString.ReportName, withString: trip.name)
            .stringByReplacingOccurrencesOfString(SmartReceiptsFormattableString.UserId, withString: WBPreferences.userID())
            .stringByReplacingOccurrencesOfString(SmartReceiptsFormattableString.ReportStart, withString: self.dateFormatter.formattedDate(trip.startDate, inTimeZone: trip.startTimeZone))
            .stringByReplacingOccurrencesOfString(SmartReceiptsFormattableString.ReportEnd, withString: self.dateFormatter.formattedDate(trip.endDate, inTimeZone: trip.endTimeZone))
    }
    
}