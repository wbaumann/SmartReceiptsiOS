//
//  DefaultSyncState.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

class DefaultSyncState: SyncState {
    private var identifierMap: IdentifierMap!
    private var syncStatusMap: SyncStatusMap!
    private var markedForDeletionMap: MarkedForDeletionMap!
    private var lastModificationDate: Date?
    
    init(identifierMap: IdentifierMap, syncStatusMap: SyncStatusMap, markedForDeletionMap: MarkedForDeletionMap, lastModificationDate: Date?) {
        self.identifierMap = identifierMap
        self.syncStatusMap = syncStatusMap
        self.markedForDeletionMap = markedForDeletionMap
        self.lastModificationDate = lastModificationDate
    }
    
    var lastLocalModificationTime: Date {
        return lastModificationDate ?? Date()
    }
    
    func getSyncId(provider: SyncProvider) -> String? {
        return identifierMap.syncId(provider: provider)
    }
    
    func isSynced(syncProvider: SyncProvider) -> Bool {
        return syncStatusMap.isSynced(provider: syncProvider)
    }
    
    func isMarkedForDeletion(syncProvider: SyncProvider) -> Bool {
        return markedForDeletionMap.isMarkedForDeletion(provider: syncProvider)
    }
    
    
}
