//
//  AppMonitorService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 21/05/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import Firebase

protocol AppMonitorService {
    func configure()
}

class AppMonitorServiceFactory {
    func createAppMonitor() -> AppMonitorService {
        if ProcessInfo.processInfo.environment["Test"] == nil {
            return FirebaseAppMonitorService()
        }
        return NoOpAppMonitorService()
    }
}

//MARK: Implementations

class FirebaseAppMonitorService: AppMonitorService {
    func configure() {
        FirebaseApp.configure()
        setupCustomExceptionHandler()
        enableAnalytics()
        applyPrivacySettings()
    }
    
    private func enableAnalytics() {
        AnalyticsManager.sharedManager.register(newService: FirebaseAnalytics())
        AnalyticsManager.sharedManager.register(newService: AnalyticsLogger())
    }
    
    private func applyPrivacySettings() {
        AnalyticsManager.sharedManager.setAnalyticsSending(allowed: WBPreferences.analyticsEnabled())
        if WBPreferences.crashTrackingEnabled() { Fabric.with([Crashlytics.self]) }
    }
    
    private func setupCustomExceptionHandler() {
        // Catches most but not all fatal errors
        NSSetUncaughtExceptionHandler { exception in
            RateApplication.sharedInstance().markAppCrash()
            
            var message = exception.description
            message += "\n"
            message += exception.callStackSymbols.description
            Logger.error(message, file: "UncaughtExcepetion", function: "onUncaughtExcepetion", line: 0)
            Crashlytics.sharedInstance().recordCustomExceptionName(exception.name.rawValue, reason: exception.reason, frameArray: [])
            
            let errorEvent = ErrorEvent(exception: exception)
            AnalyticsManager.sharedManager.record(event: errorEvent)
        }
    }
}


class NoOpAppMonitorService: AppMonitorService {
    func configure() {}
}



