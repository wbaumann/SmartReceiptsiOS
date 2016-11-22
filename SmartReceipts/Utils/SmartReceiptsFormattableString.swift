//
//  SmartReceiptsFormattableString.swift
//  SmartReceipts
//
//  Created by William Baumann on 7/1/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

class SmartReceiptsFormattableString : NSObject {
    
    fileprivate static let ReportName = "%REPORT_NAME%";
    fileprivate static let UserId = "%USER_ID%";
    fileprivate static let ReportStart = "%REPORT_START%";
    fileprivate static let ReportEnd = "%REPORT_END%";
    
    fileprivate let originalText: String
    fileprivate let dateFormatter: WBDateFormatter
    
    init(fromOriginalText originalText: String) {
        self.originalText = originalText
        self.dateFormatter = WBDateFormatter();
    }
    
    func format(_ trip: WBTrip) -> String {
        return self.originalText
            .replacingOccurrences(of: SmartReceiptsFormattableString.ReportName, with: trip.name)
            .replacingOccurrences(of: SmartReceiptsFormattableString.UserId, with: WBPreferences.userID())
            .replacingOccurrences(of: SmartReceiptsFormattableString.ReportStart, with: self.dateFormatter.formattedDate(trip.startDate, in: trip.startTimeZone))
            .replacingOccurrences(of: SmartReceiptsFormattableString.ReportEnd, with: self.dateFormatter.formattedDate(trip.endDate, in: trip.endTimeZone))
    }
    
}
