//
//  DataImport.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Zip
import RxSwift

class DataImport: NSObject {
    
    var inputPath: String!
    var outputPath: String!
    
    init(inputFile: String, output: String) {
        super.init()
        self.inputPath = inputFile
        self.outputPath = output
        Zip.addCustomFileExtension(inputPath.asNSString.pathExtension)
    }
    
    func execute(overwrite: Bool = false) -> Observable<Void> {
        return Observable<Void>.create({ [unowned self] observer -> Disposable in
            do {
                try FileManager.default.createDirectory(atPath: self.outputPath, withIntermediateDirectories: true, attributes: nil)
                try Zip.unzipFile(self.inputPath.asFileURL, destination: self.outputPath.asFileURL, overwrite: true, password: nil)
                
                // DB
                let backupPath = FileManager.pathInDocuments(relativePath: SmartReceiptsDatabaseExportName)
                if Database.sharedInstance().importData(fromBackup: backupPath, overwrite: overwrite) {
                    
                    // Preferences
                    let prefPath = self.outputPath.asNSString.appendingPathComponent(SmartReceiptsPreferencesExportName)
                    if let prefData = try? Data(contentsOf: prefPath.asFileURL) {
                        WBPreferences.setFromXmlString(String(data: prefData, encoding: .utf8))
                        try? FileManager.default.removeItem(at: prefPath.asFileURL.deletingLastPathComponent())
                    }
                    
                    // Trips
                    let trips = self.outputPath.asNSString.appendingPathComponent(SmartReceiptsTripsDirectoryName).asFileURL
                    (try? FileManager.default.contentsOfDirectory(atPath: self.outputPath))?.forEach({ item in
                        if item == SmartReceiptsTripsDirectoryName ||
                           item == SmartReceiptsDatabaseName ||
                           item == SmartReceiptsDatabaseExportName { return }
                        let itemURL = self.outputPath.asNSString.appendingPathComponent(item).asFileURL
                        try? FileManager.default.moveItem(at: itemURL, to: trips.appendingPathComponent(item))
                    })
                    
                    observer.onNext(())
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: "wb.import.db.error", code: 0, userInfo: nil))
                }
                FileManager.deleteIfExists(filepath: backupPath)
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        })
    }
}
