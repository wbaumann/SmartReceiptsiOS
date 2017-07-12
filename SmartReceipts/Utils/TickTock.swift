//
//  TickTock.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 10/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class TickTock {
    
    private var tickTime: Date!
    
    private init() {
        tickTime = Date()
    }
    
    class func tick() -> TickTock {
        return TickTock()
    }
    
    func tock() -> String {
        return String(format: "%f", -tickTime.timeIntervalSinceNow)
    }
    
}
