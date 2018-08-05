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
    
    func restoreBackup(remoteBackupMetadata: RemoteBackupMetadata, overwriteExistingData: Bool) -> Completable {
        return GoogleDriveService.shared.getFiles(inFolderId: remoteBackupMetadata.id)
            .flatMap({ fileList -> Single<Bool> in
                guard let dbFile = fileList.files?.filter({ $0.name == SYNC_DB_NAME }).first else { return Single<Bool>.never() }
                return GoogleDriveService.shared.downloadFile(id: dbFile.identifier!)
                    .map({ $0.data })
                    .map({ data -> Bool in
                        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(SYNC_DB_NAME)!
                        do { try data.write(to: fileURL) } catch { return false }
                        return Database.sharedInstance().importData(fromBackup: fileURL.path, overwrite: overwriteExistingData)
                    })
            }).asCompletable()
    }
    
    func deleteBackup(remoteBackupMetadata: RemoteBackupMetadata) -> Completable {
        return Completable.empty()
    }
    
    func clearCurrentBackupConfiguration() -> Completable {
        return Completable.empty()
    }
    
    func downloadAllData(remoteBackupMetadata: RemoteBackupMetadata) -> Single<BackupFetchResult> {
        return GoogleDriveService.shared.getFiles(inFolderId: remoteBackupMetadata.id)
            .flatMap({ fileList -> Single<BackupFetchResult> in
                guard let dbFile = fileList.files?.filter({ $0.name == SYNC_DB_NAME }).first else { return Single<BackupFetchResult>.never() }
                guard let receiptFiles = fileList.files?.filter({ $0.name != SYNC_DB_NAME }) else { return Single<BackupFetchResult>.never() }
                return GoogleDriveService.shared.downloadFile(id: dbFile.identifier!).asObservable()
                    .map({ $0.data })
                    .map({ data -> String in
                        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(SYNC_DB_NAME)!
                        try? data.write(to: fileURL)
                        return fileURL.absoluteString
                    }).map({ dbPath -> Database in
                        return Database(databasePath: dbPath, tripsFolderPath: FileManager.tripsDirectoryPath)!
                    }).flatMap({ database -> Observable<BackupFetchResult> in
                        var observables = [Observable<BackupReceiptFile>]()
                        for file in receiptFiles {
                            if file.name! == SYNC_DB_NAME {  }
                            observables.append(GoogleDriveService.shared.downloadFile(id: file.identifier!).asObservable()
                                .map({ $0.data })
                                .map({ (file.name!, $0) }))
                        }
                        
                        return Observable<(BackupReceiptFile)>.merge(observables).toArray()
                            .map({ downloadedFiles -> BackupFetchResult in
                                return BackupFetchResult(database, downloadedFiles)
                            })
                    }).asSingle()
            })
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
