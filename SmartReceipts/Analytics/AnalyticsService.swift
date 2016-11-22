//
//  AnalyticsService.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 16/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

enum Event {
    
}

protocol AnalyticsService {
    func sendEvent(_ event: Event)
}
