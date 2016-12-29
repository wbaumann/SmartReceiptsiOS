//
//  AnalyticsLogger.swift
//  SmartReceipts
//
//  Created by Victor on 12/20/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

class AnalyticsLogger: AnalyticsServiceProtocol {
    
    // TODO: integrate cocoalumberjack
    
    init() {
        // initial configuration
    }
    
    func record(event: Event) {
        // format: "Logging Event: {} with datapoints: {}" event.name, datapoints
        let datapointLabelString = event.datapointsToFormattedString()
        let logString = "Logging Event: {\(event.name)} with datapoints: \(datapointLabelString))"
        Log.debug(logString)
    }
}


