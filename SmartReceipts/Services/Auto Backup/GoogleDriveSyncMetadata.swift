//
//  GoogleDriveSyncMetadata.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 02/07/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

class GoogleDriveSyncMetadata {
    
    private let KEY_DEVICE_IDENTIFIER = "key_device_identifier"
    private let KEY_FOLDER_IDENTIFIER = "key_folder_identifier"
    private let KEY_DRIVE_DATABASE_IDENTIFIER = "key_drive_database_identifier"
    private let KEY_DRIVE_LAST_SYNC = "key_drive_last_sync"
    
    var deviceIdentifier: String {
        if let id = UserDefaults.standard.string(forKey: KEY_DEVICE_IDENTIFIER) {
            return id
        } else {
            let id = UUID().uuidString
            UserDefaults.standard.set(id, forKey: KEY_DEVICE_IDENTIFIER)
            return id
        }
    }
    
    var folderIdentifier: String? {
        get { return UserDefaults.standard.string(forKey: KEY_FOLDER_IDENTIFIER) }
        set { UserDefaults.standard.set(newValue, forKey: KEY_FOLDER_IDENTIFIER) }
    }
    
    var databaseSyncIdentifier: String? {
        get { return UserDefaults.standard.string(forKey: KEY_DRIVE_DATABASE_IDENTIFIER) }
        
        set {
            UserDefaults.standard.set(newValue, forKey: KEY_DRIVE_DATABASE_IDENTIFIER)
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: KEY_DRIVE_LAST_SYNC)
        }
    }
    
    func getLastDatabaseSyncTime() -> Date? {
        let timeInterval = UserDefaults.standard.double(forKey: KEY_DRIVE_LAST_SYNC)
        if timeInterval == 0 { return nil }
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    func clear() {
        UserDefaults.standard.removeObject(forKey: KEY_DEVICE_IDENTIFIER)
        UserDefaults.standard.removeObject(forKey: KEY_DRIVE_DATABASE_IDENTIFIER)
        UserDefaults.standard.removeObject(forKey: KEY_DRIVE_LAST_SYNC)
    }
}
