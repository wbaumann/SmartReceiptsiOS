//
//  GoogleAnalytics.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 16/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation
import Google

class GoogleAnalytics: AnalyticsService {
    
    private let gai: GAI
    
    init() {
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        self.gai = GAI.sharedInstance()
        self.gai.trackUncaughtExceptions = false
        self.gai.logger.logLevel = .Warning
        
        self.gai.defaultTracker.send(GAIDictionaryBuilder.createEventWithCategory("Overall", action: "AppLaunch", label: nil, value: nil).build()  as [NSObject : AnyObject])
    }
    
    func sendEvent(event: Event) {
        assert(true == false, "We don't support actual events yet");
    }
}