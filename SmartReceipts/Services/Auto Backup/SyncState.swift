//
//  SyncState.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

protocol SyncState {
    
    /**
     * Gets the last time (in UTC) that this item was modified locally
     *
     * @return the last Date time this item was modified
     */
    var lastLocalModificationTime: Date { get }
    
    /**
     * Gets the unique id associated with the "cloud" version of this object
     *
     * @param provider the SyncProvider for this identifier
     * @return the String instance or nil if this is an unknown provider
     */
    func getSyncId(provider: SyncProvider) -> String?
    
    /**
     * Checks if this item has been synced
     *
     * @param provider the SyncProvider for to check for
     * @return true if this item is synced
     */
    func isSynced(syncProvider: SyncProvider) -> Bool

    /**
     * Checks if this item has been marked for deletion
     *
     * @param provider the SyncProvider for to check for
     * @return true if this item is marked for remote deletion
     */
    func isMarkedForDeletion(syncProvider: SyncProvider) -> Bool
}
