//
//  FirebaseAnalytics.swift
//  SmartReceipts
//
//  Created by Victor on 12/17/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation
import FirebaseAnalytics
import Firebase

/// Firebase implementation adopted to our custom Analytics service
class FirebaseAnalytics: AnalyticsServiceProtocol {
    
    init() {
        // Configure Firebase
        // May conflict with Google services, here is a solution:
        if FirebaseApp.app() == nil {
            AppMonitorServiceFactory().createAppMonitor().configure()
        }
    }
    
    func record(event: Event) {
        // building a Dictionary with parameters (category and datapoints included)
        let dictionaryParameters: NSMutableDictionary = ["Category" : event.category.rawValue]
        for aDataPoint in event.dataPoints {
            dictionaryParameters.setValue(aDataPoint.toString().truncateToLength(100), forKey: aDataPoint.name.truncateToLength(40))
        }
        // cast to appropriate type:
        let parameters = dictionaryParameters as NSDictionary as? [String: NSObject] ?? [:]
        
        // Firebase tracks all crashes automatically. For iOS, exceptions will be tracked as an "error" events
        Analytics.logEvent(event.name, parameters: parameters)
    }
    
    func setAnalyticsSending(allowed: Bool) {
        Analytics.setAnalyticsCollectionEnabled(allowed)
    }
}
