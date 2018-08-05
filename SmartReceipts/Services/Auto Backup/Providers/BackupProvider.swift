//
//  BackupProvider.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 30/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift

enum SyncErrorType {
    case noRemoteDiskSpace, userRevokedRemoteRights, userDeletedRemoteData
}

typealias BackupReceiptFile = (filename: String, data: Data)
typealias BackupFetchResult = (database: Database, files: [BackupReceiptFile])

/**
 * A top level interface to track the core behaviors that are shared by all automatic backup providers
 */
protocol BackupProvider {
    
    /**
     * @return the sync Identifier for the current device or nil if none is defined
     */
    var deviceSyncId: String? { get }
    
    /**
     * @return the Date for the last time our database was synced
     */
    var lastDatabaseSyncTime: Date { get }
    
    /**
     * De-initialize the backup provider to stop it from being used
     */
    func deinitialize()
    
    /**
     * @return an Single containing all of our remote backups
     */
    func getRemoteBackups() -> Single<[RemoteBackupMetadata]>
    
    /**
     * Restores an existing backup
     *
     * @param remoteBackupMetadata the metadata to restore
     * @param overwriteExistingData if we should overwrite the existing data
     * @return a Single for the restore operation with a success boolean
     */
    func restoreBackup(remoteBackupMetadata: RemoteBackupMetadata, overwriteExistingData: Bool) -> Completable
    
    /**
     * Deletes an existing backup
     *
     * @param remoteBackupMetadata the metadata to delete
     * @return an {@link Single} for the delete operation with a success boolean
     */
    func deleteBackup(remoteBackupMetadata: RemoteBackupMetadata) -> Completable
    
    /**
     * Attempts to clear out the current backup configuration
     *
     * @return a Single for the delete operation with a success boolean
     */
    func clearCurrentBackupConfiguration() -> Completable
    
    /**
     * Downloads an existing backup to a specific location
     *
     * @param remoteBackupMetadata the metadata to download
     * @return a Single that contains the downloaded images
     */
    func downloadAllData(remoteBackupMetadata: RemoteBackupMetadata) -> Single<BackupFetchResult>
    
    /**
     * Downloads an existing backup to a specific location in a debug friendly manner
     *
     * @param remoteBackupMetadata the metadata to download
     * @return an Single that contains the downloaded images
     */
    func debugDownloadAllData(remoteBackupMetadata: RemoteBackupMetadata) -> Single<BackupFetchResult>
    
    /**
     * @return an Observable that emits CriticalSyncError instances whenever they occur,
     * allowing us to respond as appropriately for these items
     */
    func getCriticalSyncErrorStream() -> Observable<CriticalSyncError>
    
    /**
     * Call this method to mark this particular error as resolve
     *
     * @param syncErrorType the SyncErrorType to mark as resolved
     */
    func markErrorResolved(syncErrorType: SyncErrorType)
    
    
}
