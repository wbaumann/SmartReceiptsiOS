//
//  Database+Sync.swift
//  SmartReceipts
//
//  Created by Victor on 4/3/17.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import FMDB

/// Adds sync behavior to the Database tables
extension Database {
    
    struct SyncColumns {
        static let drive_sync_id = "drive_sync_id"
        static let drive_is_synced = "drive_is_synced"
        static let drive_marked_for_deletion = "drive_marked_for_deletion"
        static let last_local_modification_time = "last_local_modification_time"
    }
    
    // TODO: make something like AbstractSqlTable (Rx? )
    // TODO: sync
}
