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
        Analytics.sharedInstance.addService(GoogleAnalytics())
    }
    
    func enableLogging() {
        Log.logLevel = .DEBUG
        Log.addOutput(ConsoleOutput())
    }
}