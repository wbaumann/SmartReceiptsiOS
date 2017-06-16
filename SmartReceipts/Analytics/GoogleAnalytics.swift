//
//  GoogleAnalytics.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 16/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation
import Google

/// GA implementation adopted to our custom Analytics service
class GoogleAnalytics: AnalyticsServiceProtocol {
    
    private var gai: GAI?
    
    init() {
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError!.localizedDescription)")
        
        // Optional: configure GAI options.
        gai = GAI.sharedInstance()
        gai?.trackUncaughtExceptions = false
        gai?.logger.logLevel = GAILogLevel.warning
    }
    
    func record(event: Event) {
        var gaiEvent: NSMutableDictionary
        let datapointLabelString = event.datapointsToFormattedString()
        
        if event is ErrorEvent {
            if (event as! ErrorEvent).isException {
                // Track as exception
                gaiEvent = GAIDictionaryBuilder.createException(withDescription: datapointLabelString, withFatal: 0).build()
            } else {
                // Track as Error
                gaiEvent = GAIDictionaryBuilder.createEvent(withCategory: event.category.rawValue, action: event.name, label: datapointLabelString, value: nil).build()
            }
        } else {
            // A regular event
            gaiEvent = GAIDictionaryBuilder.createEvent(withCategory: event.category.rawValue, action: event.name, label: datapointLabelString, value: nil).build()
        }
        
        gai?.defaultTracker.send(gaiEvent as NSDictionary as? [AnyHashable: Any] ?? [:])
    }
    
}
