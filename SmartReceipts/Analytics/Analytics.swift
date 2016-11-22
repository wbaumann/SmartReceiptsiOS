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
    fileprivate var services = [AnalyticsService]()
    
    func addService(_ service: AnalyticsService) {
        onMainThread() {
            self.services.append(service)
        }
    }
    
    func sendEvent(_ event: Event) {
        onMainThread() {
            for service in self.services {
                service.sendEvent(event)
            }
        }
    }
}
