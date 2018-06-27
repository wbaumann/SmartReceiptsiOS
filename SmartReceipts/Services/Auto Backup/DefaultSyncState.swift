//
//  DefaultSyncState.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

class DefaultSyncState: SyncState {
    
    var lastLocalModificationTime: Date { return Date() }
    
    func isSynced(syncProvider: SyncProvider) -> Bool {
        return false
    }
    
    func isMarkedForDeletion(syncProvider: SyncProvider) -> Bool {
        return false
    }
    
    
}
