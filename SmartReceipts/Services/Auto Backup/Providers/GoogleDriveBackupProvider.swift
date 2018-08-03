//
//  GoogleDriveBackupProvider.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 30/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift

class GoogleDriveBackupProvider: BackupProvider {
    
    var deviceSyncId: String? {
        return nil
    }
    
    var lastDatabaseSyncTime: Date {
        return Date(timeIntervalSince1970: 0)
    }
    
    func deinitialize() {
        
    }
    
    func getRemoteBackups() -> Single<[RemoteBackupMetadata]> {
        return GoogleDriveService.shared.getFolders(name: SYNC_FOLDER_NAME)
            .map({ list -> [RemoteBackupMetadata] in
                var result = [RemoteBackupMetadata]()
                guard let files = list.files else { return result }
                for file in files {
                    result.append(DefaultRemoteBackupMetadata(file: file))
                }
                return result
            })
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
