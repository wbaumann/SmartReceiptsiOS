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
}


class NoOpAppMonitorService: AppMonitorService {
    func configure() {}
}



