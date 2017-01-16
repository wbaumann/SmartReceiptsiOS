//
//  WBAppDelegate.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 17/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension WBAppDelegate {
    
    func enableAnalytics() {
        AnalyticsManager.sharedManager.register(newService: GoogleAnalytics())
        AnalyticsManager.sharedManager.register(newService: FirebaseAnalytics())
        AnalyticsManager.sharedManager.register(newService: AnalyticsLogger())
    }

}
