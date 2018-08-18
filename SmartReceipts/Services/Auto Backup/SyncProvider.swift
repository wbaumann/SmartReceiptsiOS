//
//  SyncProvider.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import RxCocoa

fileprivate let SYNC_PROVIDER_KEY = "sync_provider_key"
fileprivate let LAST_SYNC_PROVIDER_KEY = "last_sync_provider_key"

enum SyncProvider: Int {
    
    case none, googleDrive
    
    static var current: SyncProvider {
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: SYNC_PROVIDER_KEY)
            if newValue != .none {
                UserDefaults.standard.set(newValue.rawValue, forKey: LAST_SYNC_PROVIDER_KEY)
            }
            AppNotificationCenter.postSyncProviderChanged(newValue)
        }
        
        get {
            let rawValue = UserDefaults.standard.integer(forKey: SYNC_PROVIDER_KEY)
            return SyncProvider(rawValue: rawValue)!
        }
    }
    
    static var last: SyncProvider {
        get {
            let rawValue = UserDefaults.standard.integer(forKey: LAST_SYNC_PROVIDER_KEY)
            return SyncProvider(rawValue: rawValue)!
        }
    }
    
    func localizedTitle() -> String {
        switch self {
        case .googleDrive:
            return LocalizedString("auto_backup_source_google_drive")
        case .none:
            return LocalizedString("auto_backup_source_none")
        }
    }
}

