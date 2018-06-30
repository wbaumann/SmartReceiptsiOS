//
//  SyncProvider.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

fileprivate let SYNC_PROVIDER_KEY = "sync_provider_key"

enum SyncProvider: Int {
    case none, googleDrive
    
    static var current: SyncProvider {
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: SYNC_PROVIDER_KEY)
        }
        
        get {
            let rawValue = UserDefaults.standard.integer(forKey: SYNC_PROVIDER_KEY)
            return SyncProvider(rawValue: rawValue)!
        }
    }
}
