//
//  AnalyticsLogger.swift
//  SmartReceipts
//
//  Created by Victor on 12/20/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

class AnalyticsLogger: AnalyticsServiceProtocol {
    
    func record(event: Event) {
        // format: "Logging Event: {} with datapoints: {}" event.nwame, datapoints
        let datapointLabelString = event.datapointsToFormattedString()
        let logString = "Logging Event: {\(event.name)} with datapoints: \(datapointLabelString))"
        
        Logger.verbose(logString)
    }
    
    func setAnalyticsSending(allowed: Bool) {
        
    }
}


