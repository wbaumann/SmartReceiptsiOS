//
//  DebugStates.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

@objc class DebugStates: NSObject {
    private static var _subscription = false
    
    static func setSubscription(_ enabled: Bool) {
        _subscription = enabled
    }

    static func subscription() -> Bool {
        return isDebug && _subscription
    }
    
    static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
}
