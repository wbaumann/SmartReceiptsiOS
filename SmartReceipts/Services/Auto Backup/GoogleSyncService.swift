//
//  GoogleSyncService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15/07/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift
import GoogleAPIClientForREST
import Toaster

let SYNC_FOLDER_NAME = "Smart Receipts"
let SYNC_UDID_PROPERTY = "smart_receipts_id"
let SYNC_DB_NAME = "receipts.db"

fileprivate let DB_MIME = "application/x-sqlite3"
fileprivate let DB_PDF_MIME = "application/pdf"

class GoogleSyncService: SyncServiceProtocol {
    
    private let bag = DisposeBag()
    private let syncMetadata = GoogleDriveSyncMetadata()
    private let syncQueue = DispatchQueue(label: "sync.queue")
    
    private let dbLock = NSLock()
    func syncDatabase() {
        let dbPath = Database.sharedInstance().pathToDatabase!
        let data = try! Data(contentsOf: URL(fileURLWithPath: dbPath))
        
        syncQueue.async {
            self.dbLock.lock()
            var upload: Single<GTLRDrive_File>!
            if let databaseId = self.syncMetadata.databaseSyncIdentifier {
                let file = GTLRDrive_File()
                file.name = SYNC_DB_NAME
                upload = GoogleDriveService.shared.updateFile(id: databaseId, file: file, data: data, mimeType: DB_MIME)
            } else {
                upload = self.createBackupFolder()
                    .flatMap({ folderId -> Single<GTLRDrive_File> in
                        return GoogleDriveService.shared.createFile(name: SYNC_DB_NAME, data: data, mimeType: DB_MIME, parent: folderId)
                    })
            }
            
            upload.do(onSuccess: { file in
                self.syncMetadata.databaseSyncIdentifier = file.identifier
                AppNotificationCenter.postDidSyncBackup()
                self.dbLock.unlock()
            }).do(onError: { _ in
                self.dbLock.unlock()
            }).subscribe(onSuccess: { file in
                Logger.debug("DB Synced")
            }, onError: { error in
                Logger.error("DB Sync Error - \(error.localizedDescription)")
            }).disposed(by: self.bag)
        }
    }
    
    func uploadFile(receipt: WBReceipt) {
        let name = receipt.imageFileName()
        let mime = receipt.attachemntType == .pdf ? DB_PDF_MIME : "image/\(name.asNSString.pathExtension)"
        let imageFileURL = receipt.imageFilePath(for: receipt.trip).asFileURL
        guard let data = try? Data(contentsOf: imageFileURL) else { return }
        
        var upload: Single<GTLRDrive_File>!
        if let folderId = syncMetadata.folderIdentifier {
            upload = GoogleDriveService.shared.createFile(name: name, data: data, mimeType: mime, parent: folderId)
        } else {
            upload = createBackupFolder()
                .flatMap({ folderId -> Single<GTLRDrive_File> in
                    return GoogleDriveService.shared.createFile(name: name, data: data, mimeType: mime, parent: folderId)
                })
        }
        
        upload.do(onSuccess: { _ in
            AppNotificationCenter.postDidSyncBackup()
        }).subscribe(onSuccess: { [unowned self] file in
            receipt.isSynced = true
            receipt.syncId = file.identifier!
            Database.sharedInstance().save(receipt)
            self.syncDatabase()
            Logger.debug("Synced file for receipt: \(receipt.name)")
        }).disposed(by: bag)
    }
    
    func deleteFile(receipt: WBReceipt) {
        receipt.isMarkedForDeletion = true
        receipt.isSynced = false
        
        // We can't call save and delete here.
        // It's not safe for FetchedTableView, we can't guarantee safe call, because it's async operation.
        
        guard let syncID = receipt.getSyncId(provider: .current), !syncID.isEmpty else { return }
        GoogleDriveService.shared.deleteFile(id: syncID)
            .do(onCompleted: {
                AppNotificationCenter.postDidSyncBackup()
            }).subscribe(onCompleted: {
                Database.sharedInstance().delete(receipt)
                Logger.debug("Delete synced receipt: \(receipt.name)")
            }, onError: { error in
                Database.sharedInstance().save(receipt)
                Logger.error("Delete Receipt file error - \(error.localizedDescription)")
                Logger.debug("Mark for delete receipt: \(receipt.name)")
            }).disposed(by: bag)
    }
    
    func replaceFile(receipt: WBReceipt) {
        guard let syncID = receipt.getSyncId(provider: .current), !syncID.isEmpty else { return }
        GoogleDriveService.shared.deleteFile(id: syncID)
            .do(onCompleted: {
                AppNotificationCenter.postDidSyncBackup()
            }).subscribe(onCompleted: {
                self.uploadFile(receipt: receipt)
                Logger.debug("Replacing file of receipt: \(receipt.name)")
            }, onError: { error in
                Database.sharedInstance().save(receipt)
                Logger.error("Delete Receipt file error - \(error.localizedDescription)")
                Logger.debug("Mark for delete receipt: \(receipt.name)")
            }).disposed(by: bag)
    }
    
    private let folderLock = NSLock()
    private func createBackupFolder() -> Single<String> {
        return Single<String>.create(subscribe: { single -> Disposable in
            self.syncQueue.async {
                let json = self.folderCustomProperties()
                self.folderLock.lock()
                
                if let folderId = self.syncMetadata.folderIdentifier {
                    single(.success(folderId))
                    self.folderLock.unlock()
                    return
                }
                
                GoogleDriveService.shared
                    .createFolder(name: SYNC_FOLDER_NAME, json: json, description: UIDevice.current.name)
                    .do(onSuccess: { [weak self] file in
                        self?.syncMetadata.folderIdentifier = file.identifier
                        self?.folderLock.unlock()
                        single(.success(file.identifier!))
                        Logger.debug("Created Sync Folder")
                    }).do(onError: { error in
                        self.folderLock.unlock()
                        single(.error(error))
                        Logger.error("Create Sync Folder Error - \(error.localizedDescription)")
                    }).subscribe().disposed(by: self.bag)
            }
            return Disposables.create()
        })
    }
    
    private func folderCustomProperties() -> [AnyHashable: Any]? {
        var properties = [String: String]()
        properties[SYNC_UDID_PROPERTY] = syncMetadata.deviceIdentifier
        return properties
    }
    
}
