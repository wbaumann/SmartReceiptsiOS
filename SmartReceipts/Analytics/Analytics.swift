//
//  Analytics.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 16/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

class Analytics: AnalyticsService {
    static let sharedInstance = Analytics()
    private var services = [AnalyticsService]()
    
    func addService(service: AnalyticsService) {
        onMainThread() {
            self.services.append(service)
        }
    }
    
    func sendEvent(event: Event) {
        onMainThread() {
            for service in self.services {
                service.sendEvent(event)
            }
        }
    }
}