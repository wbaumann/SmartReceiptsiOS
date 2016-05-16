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
    init() {
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = false
        #if DEBUG
        gai.logger.logLevel = .Verbose
        #endif
    }
    
    func sendEvent(event: Event) {

    }
}