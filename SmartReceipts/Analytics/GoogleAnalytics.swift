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
    
    fileprivate let gai: GAI
    
    init() {
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        self.gai = GAI.sharedInstance()
        self.gai.trackUncaughtExceptions = false
        self.gai.logger.logLevel = .warning
        
        let event = GAIDictionaryBuilder.createEvent(withCategory: "Overall", action: "AppLaunch", label: nil, value: nil).build() as NSDictionary as? [AnyHashable: Any] ?? [:]
        
        self.gai.defaultTracker.send(event)
    }
    
    func sendEvent(_ event: Event) {
        assert(true == false, "We don't support actual events yet");
    }
}
