//
//  AnalyticsManager.swift
//  SmartReceipts
//
//  Created by Victor on 12/13/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

/// Any analytics library should conform to this protocol
protocol AnalyticsServiceProtocol: class {
    
    /// Records a specific event
    ///
    /// - Parameter event: the Event to record
    func record(event: Event)
    func setAnalyticsSending(allowed: Bool)
}

/// Main class for logging events
class AnalyticsManager: NSObject {
    
    /// Singleton
    static let sharedManager = AnalyticsManager()
    
    /// A list of analytics providers
    private var analyticsServices = [AnalyticsServiceProtocol]()
    
    /// Hidden initializer
    private override init () {
        // initialization here
    }
    
    /// Registers analytics service provider
    ///
    /// - Parameter newService: object, which conforms to AnalyticsServiceProtocol
    func register(newService: AnalyticsServiceProtocol) {
        analyticsServices.append(newService)
    }
    
    /// Records a specific event
    ///
    /// - Parameter event: the Event to record
    func record(event: Event) {
        for aService in analyticsServices {
            aService.record(event: event)
        }
    }
    
    func setAnalyticsSending(allowed: Bool) {
        for aService in analyticsServices {
            aService.setAnalyticsSending(allowed: allowed)
        }
    }
}
