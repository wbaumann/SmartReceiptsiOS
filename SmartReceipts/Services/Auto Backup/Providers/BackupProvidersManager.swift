//
//  BackupProvidersManager.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 30/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift

class BackupProvidersManager: BackupProvider {
    
    var backupProvider: BackupProvider
    
    init(syncProvider: SyncProvider) {
        backupProvider = BackupProviderFactory().makeBackupProvider(syncProvider: syncProvider)
    }
    
    init(backupProvider: BackupProvider) {
        self.backupProvider = backupProvider
    }
    
    var deviceSyncId: String? {
        return backupProvider.deviceSyncId
    }
    
    var lastDatabaseSyncTime: Date { return backupProvider.lastDatabaseSyncTime }
    
    func deinitialize() {
        
    }
    
    func getRemoteBackups() -> Single<[RemoteBackupMetadata]> {
        return backupProvider.getRemoteBackups()
    }
    
    func restoreBackup(remoteBackupMetadata: RemoteBackupMetadata, overwriteExistingData: Bool) -> Single<Bool> {
        return backupProvider.restoreBackup(remoteBackupMetadata: remoteBackupMetadata, overwriteExistingData: overwriteExistingData)
    }
    
    func deleteBackup(remoteBackupMetadata: RemoteBackupMetadata) -> Single<Bool> {
        return backupProvider.deleteBackup(remoteBackupMetadata: remoteBackupMetadata)
    }
    
    func clearCurrentBackupConfiguration() -> Completable {
        return backupProvider.clearCurrentBackupConfiguration()
    }
    
    func downloadAllData(remoteBackupMetadata: RemoteBackupMetadata, downloadLocation: URL) -> Single<[URL]> {
        return backupProvider.downloadAllData(remoteBackupMetadata:remoteBackupMetadata, downloadLocation: downloadLocation)
    }
    
    func debugDownloadAllData(remoteBackupMetadata: RemoteBackupMetadata, downloadLocation: URL) -> Single<[URL]> {
        return backupProvider.debugDownloadAllData(remoteBackupMetadata:remoteBackupMetadata, downloadLocation: downloadLocation)
    }
    
    func getCriticalSyncErrorStream() -> Observable<CriticalSyncError> {
        return backupProvider.getCriticalSyncErrorStream()
    }
    
    func markErrorResolved(syncErrorType: SyncErrorType) {
        backupProvider.markErrorResolved(syncErrorType: syncErrorType)
    }
}
