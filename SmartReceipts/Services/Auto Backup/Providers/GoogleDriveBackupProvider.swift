//
//  GoogleDriveBackupProvider.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 30/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift

fileprivate let DB_SYNC_ID_KEY = "google.drive.sync.id.key"

class GoogleDriveBackupProvider: BackupProvider {
    
    var databaseSyncId: String? {
        get { return UserDefaults.standard.string(forKey: DB_SYNC_ID_KEY) }
        set { UserDefaults.standard.set(newValue, forKey: DB_SYNC_ID_KEY) }
    }
    
    var lastDatabaseSyncTime: Date {
        return Date(timeIntervalSince1970: 0)
    }
    
    func deinitialize() {
        
    }
    
    func getRemoteBackups() -> Single<[RemoteBackupMetadata]> {
        return Single<[RemoteBackupMetadata]>.just([])
    }
    
    func restoreBackup(remoteBackupMetadata: RemoteBackupMetadata, overwriteExistingData: Bool) -> Single<Bool> {
        return Single<Bool>.just(false)
    }
    
    func deleteBackup(remoteBackupMetadata: RemoteBackupMetadata) -> Single<Bool> {
        return Single<Bool>.just(false)
    }
    
    func clearCurrentBackupConfiguration() -> Completable {
        return Completable.empty()
    }
    
    func downloadAllData(remoteBackupMetadata: RemoteBackupMetadata, downloadLocation: URL) -> Single<[URL]> {
        return Single<[URL]>.just([])
    }
    
    func debugDownloadAllData(remoteBackupMetadata: RemoteBackupMetadata, downloadLocation: URL) -> Single<[URL]> {
        return Single<[URL]>.just([])
    }
    
    func getCriticalSyncErrorStream() -> Observable<CriticalSyncError> {
        return Observable<CriticalSyncError>.empty()
    }
    
    func markErrorResolved(syncErrorType: SyncErrorType) {
        
    }
}
