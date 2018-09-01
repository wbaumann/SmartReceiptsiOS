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
    static let shared = BackupProvidersManager()
    
    private var bag = DisposeBag()
    private var backupProvider: BackupProvider
    private var syncErrorsSubject = BehaviorSubject<SyncError?>(value: nil)
    
    private init() {
        backupProvider = BackupProviderFactory().makeBackupProvider(syncProvider: .current)
        AppNotificationCenter.syncProvider.subscribe(onNext: { provider in
            self.backupProvider = BackupProviderFactory().makeBackupProvider(syncProvider: .current)
        }).disposed(by: bag)
    }
    
    var deviceSyncId: String? {
        return backupProvider.deviceSyncId
    }
    
    var lastDatabaseSyncTime: Date {
        return backupProvider.lastDatabaseSyncTime
    }
    
    func deinitialize() {
        
    }
    
    func getRemoteBackups() -> Single<[RemoteBackupMetadata]> {
        return backupProvider.getRemoteBackups()
    }
    
    func restoreBackup(remoteBackupMetadata: RemoteBackupMetadata, overwriteExistingData: Bool) -> Completable {
        return backupProvider.restoreBackup(remoteBackupMetadata: remoteBackupMetadata, overwriteExistingData: overwriteExistingData)
    }
    
    func deleteBackup(remoteBackupMetadata: RemoteBackupMetadata) -> Completable {
        return backupProvider.deleteBackup(remoteBackupMetadata: remoteBackupMetadata)
    }
    
    func clearCurrentBackupConfiguration() -> Completable {
        return backupProvider.clearCurrentBackupConfiguration()
    }
    
    func downloadDatabase(remoteBackupMetadata: RemoteBackupMetadata) -> Single<Database> {
        return backupProvider.downloadDatabase(remoteBackupMetadata:remoteBackupMetadata)
    }
    
    func downloadReceiptFile(syncId: String) -> Single<BackupReceiptFile> {
        return backupProvider.downloadReceiptFile(syncId: syncId)
    }
    
    func downloadAllData(remoteBackupMetadata: RemoteBackupMetadata) -> Single<BackupFetchResult> {
        return backupProvider.downloadAllData(remoteBackupMetadata:remoteBackupMetadata)
    }
    
    func debugDownloadAllData(remoteBackupMetadata: RemoteBackupMetadata) -> Single<BackupFetchResult> {
        return backupProvider.debugDownloadAllData(remoteBackupMetadata:remoteBackupMetadata)
    }
    
    func getCriticalSyncErrorStream() -> Observable<SyncError> {
        let syncServiceErrors = SyncService.shared.getCriticalSyncErrorStream().filter({ $0 != nil }).map({ $0! })
        let observables = [backupProvider.getCriticalSyncErrorStream(), syncServiceErrors]
        Observable<SyncError>.merge(observables).bind(to: syncErrorsSubject).disposed(by: bag)
        return syncErrorsSubject.filter({ $0 != nil }).map({ $0! })
    }
    
    func markErrorResolved(syncErrorType: SyncError) {
        backupProvider.markErrorResolved(syncErrorType: syncErrorType)
        SyncService.shared.markErrorResolved(syncErrorType: syncErrorType)
        guard let currentError = try? syncErrorsSubject.value() else { return }
        if syncErrorType == currentError {
            syncErrorsSubject.onNext(nil)
        }
    }
}
