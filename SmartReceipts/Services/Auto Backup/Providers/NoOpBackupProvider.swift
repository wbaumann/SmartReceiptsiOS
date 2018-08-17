//
//  NoOpBackupProvider.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 30/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift

class NoOpBackupProvider: BackupProvider {
    
    var deviceSyncId: String? {
        return nil
    }
    
    var lastDatabaseSyncTime: Date {
        return Date(timeIntervalSince1970: 0)
    }
    
    func deinitialize() {
        
    }
    
    func getRemoteBackups() -> Single<[RemoteBackupMetadata]> {
        return Single<[RemoteBackupMetadata]>.just([])
    }
    
    func restoreBackup(remoteBackupMetadata: RemoteBackupMetadata, overwriteExistingData: Bool) -> Completable {
        return Completable.empty()
    }
    
    func deleteBackup(remoteBackupMetadata: RemoteBackupMetadata) -> Completable {
        return Completable.empty()
    }
    
    func clearCurrentBackupConfiguration() -> Completable {
        return Completable.empty()
    }
    
    func downloadDatabase(remoteBackupMetadata: RemoteBackupMetadata) -> Single<Database> {
        return Single<Database>.never()
    }
    
    func downloadReceiptFile(syncId: String) -> Single<BackupReceiptFile> {
        return Single<BackupReceiptFile>.never()
    }
    
    func downloadAllData(remoteBackupMetadata: RemoteBackupMetadata) -> Single<BackupFetchResult> {
        return Single<BackupFetchResult>.never()
    }
    
    func debugDownloadAllData(remoteBackupMetadata: RemoteBackupMetadata) -> Single<BackupFetchResult> {
        return Single<BackupFetchResult>.never()
    }
    
    func getCriticalSyncErrorStream() -> Observable<CriticalSyncError> {
        return Observable<CriticalSyncError>.empty()
    }
    
    func markErrorResolved(syncErrorType: SyncErrorType) {
        
    }
}
