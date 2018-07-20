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

fileprivate let DB_NAME = "database.db"
fileprivate let DB_MIME = "application/x-sqlite3"
fileprivate let DB_PDF_MIME = "application/pdf"
fileprivate let FOLDER_NAME = "Smart Receipts"
fileprivate let UDID_PROPERTY = "smart_receipts_id"

class GoogleSyncService: SyncServiceProtocol {
    private let bag = DisposeBag()
    private let syncMetadata = GoogleDriveSyncMetadata()
    
    func syncDatabase() {
        let dbPath = Database.sharedInstance().pathToDatabase!
        let data = try! Data(contentsOf: URL(fileURLWithPath: dbPath))
        
        var upload: Single<GTLRDrive_File>!
        if let databaseId = syncMetadata.databaseSyncIdentifier {
            let file = GTLRDrive_File()
            file.name = DB_NAME
            upload = GoogleDriveService.shared.updateFile(id: databaseId, file: file, data: data, mimeType: DB_MIME)
        } else {
            upload = createBackupFolder()
                .do(onSuccess: { [weak self] file in
                   self?.syncMetadata.folderIdentifier = file.identifier
                }).flatMap({ file -> Single<GTLRDrive_File> in
                    return GoogleDriveService.shared.createFile(name: DB_NAME, data: data, mimeType: DB_MIME, parent: file.identifier)
                })
        }
        
        upload.do(onSuccess: { [weak self] file in
            self?.syncMetadata.databaseSyncIdentifier = file.identifier
        }).subscribe(onSuccess: { file in
            Toast(text: "DB Synced").show()
        }, onError: { error in
            Toast(text: error.localizedDescription).show()
        }).disposed(by: bag)
    }
    
    
    func uploadImage(receipt: WBReceipt) {
        let name = receipt.imageFileName()
        let mime = receipt.attachemntType == .pdf ? DB_PDF_MIME : "image/\(name.asNSString.pathExtension)"
        let imageFileURL = receipt.imageFilePath(for: receipt.trip).asFileURL
        guard let data = try? Data(contentsOf: imageFileURL) else { return }
        
        var upload: Single<GTLRDrive_File>!
        if let folderId = syncMetadata.folderIdentifier {
            upload = GoogleDriveService.shared.createFile(name: name, data: data, mimeType: mime, parent: folderId)
        } else {
            upload = createBackupFolder()
                .do(onSuccess: { [weak self] file in
                    self?.syncMetadata.folderIdentifier = file.identifier
                }).flatMap({ file -> Single<GTLRDrive_File> in
                    return GoogleDriveService.shared.createFile(name: name, data: data, mimeType: mime, parent: file.identifier)
                })
        }
        
        upload.subscribe(onSuccess: { [unowned self] file in
            receipt.isSynced = true
            receipt.syncId = file.identifier!
            Database.sharedInstance().save(receipt)
            self.syncDatabase()
        }).disposed(by: bag)
    }
    
    private func createBackupFolder() -> Single<GTLRDrive_File> {
        let json = folderCustomProperties()
        return GoogleDriveService.shared.createFolder(name: FOLDER_NAME, json: json, description: UIDevice.current.name)
    }
    
    private func folderCustomProperties() -> [AnyHashable: Any]? {
        var properties = [String: String]()
        properties[UDID_PROPERTY] = syncMetadata.deviceIdentifier
        return properties
    }
    
}
