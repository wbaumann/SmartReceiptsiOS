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

class GoogleSyncService: SyncServiceProtocol {
    private let bag = DisposeBag()
    private let syncMetadata = GoogleDriveSyncMetadata()
    
    func syncDatabase() {
        let dbPath = Database.sharedInstance().pathToDatabase!
        let data = try! Data(contentsOf: URL(fileURLWithPath: dbPath))
        
        var upload: Single<GTLRDrive_File>!
        if let databaseId = syncMetadata.getDatabaseSyncIdentifier() {
            let file = GTLRDrive_File()
            file.name = DB_NAME
            upload = GoogleDriveService.shared.updateFile(id: databaseId, file: file, data: data, mimeType: DB_MIME)
        } else {
            let deviceName = UIDevice.current.name
            upload = GoogleDriveService.shared.createFolder(name: deviceName).flatMap({ file -> Single<GTLRDrive_File> in
                return GoogleDriveService.shared.createFile(name: DB_NAME, data: data, mimeType: DB_MIME, parent: file.identifier)
            })
        }
        
        upload.do(onSuccess: { [weak self] file in
            self?.syncMetadata.setDatabaseSyncIndentifier(file.identifier!)
        }).subscribe(onSuccess: { file in
            Toast(text: "DB Synced").show()
        }, onError: { error in
            Toast(text: error.localizedDescription).show()
        }).disposed(by: bag)
    }
    
}
