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
    }
}

class NoOpAppMonitorService: AppMonitorService {
    func configure() {}
}



