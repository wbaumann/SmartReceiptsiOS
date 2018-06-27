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
     * @return the last {@link Date} time this item was modified
     */
    var lastLocalModificationTime: Date { get }
    
//    /**
//     * Gets the unique id associated with the "cloud" version of this object
//     *
//     * @param provider the {@link SyncProvider} for this identifier
//     * @return the {@link Identifier} instance or {@code null} if this is an unknown provider
//     */
//    @Nullable
//    Identifier getSyncId(@NonNull SyncProvider provider);
//    
    /**
     * Checks if this item has been synced
     *
     * @param provider the {@link SyncProvider} for to check for
     * @return {@code true} if this item is synced
     */
    func isSynced(syncProvider: SyncProvider) -> Bool

    /**
     * Checks if this item has been marked for deletion
     *
     * @param provider the {@link SyncProvider} for to check for
     * @return {@code true} if this item is marked for remote deletion
     */
    func isMarkedForDeletion(syncProvider: SyncProvider) -> Bool

    
}
