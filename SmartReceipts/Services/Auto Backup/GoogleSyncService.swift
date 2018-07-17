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
    
    func syncDatabase() {
        let manager = BackupProvidersManager(syncProvider: .googleDrive)
        let dbPath = Database.sharedInstance().pathToDatabase!
        let data = try! Data(contentsOf: URL(fileURLWithPath: dbPath))
        if let databaseSyncId = manager.databaseSyncId {
            let file = GTLRDrive_File()
            file.name = DB_NAME
            GoogleDriveService.shared.updateFile(id: databaseSyncId, file: file, data: data, mimeType: DB_MIME)
                .subscribe(onSuccess: { file in
                    Toast(text: "DB Synced").show()
                }, onError: { error in
                    Toast(text: error.localizedDescription).show()
                }).disposed(by: bag)
        } else {
            let deviceName = UIDevice.current.name
            GoogleDriveService.shared.createFolder(name: deviceName)
                .flatMap({ file -> Single<GTLRDrive_File> in
                    return GoogleDriveService.shared.createFile(name: DB_NAME, data: data, mimeType: DB_MIME, parent: file.identifier)
                }).do(onSuccess: { file in
                    manager.databaseSyncId = file.identifier
                }).subscribe(onSuccess: { file in
                    Toast(text: "DB Synced").show()
                }, onError: { error in
                    Toast(text: error.localizedDescription).show()
                }).disposed(by: bag)
        }
    }
    
}
