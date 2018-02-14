//
//  DataExport.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Zip

class DataExport: NSObject {
    var workDirectory: String!
    
    init(workDirectory: String) {
        super.init()
        self.workDirectory = workDirectory
    }
    
    func execute() -> String {
        let zipPath = workDirectory.asNSString.appendingPathComponent(backupName)
        
        Logger.debug("Execute at path: \(zipPath)")
        
        // Trips
        var files = tripsFiles()
        
        // DB
        let dbPath = workDirectory.asNSString.appendingPathComponent(SmartReceiptsDatabaseName)
        let dbData = try! Data(contentsOf: dbPath.asFileURL)
        let dbExportPath = workDirectory.asNSString.appendingPathComponent(SmartReceiptsDatabaseExportName)
        _ = FileManager.forceWrite(data: dbData, to: dbExportPath)
        files.append(dbExportPath.asFileURL)
        
        // Preferences
        let preferences = WBPreferences.xmlString().data(using: .utf8)
        let prefPath = workDirectory.asNSString.appendingPathComponent(SmartReceiptsPreferencesExportName)
        let prefExportURL = prefPath.asNSString.deletingLastPathComponent.asFileURL
        _ = FileManager.forceWrite(data: preferences!, to: prefPath)
        files.append(prefExportURL)
        
        do {
            try Zip.zipFiles(paths: files, zipFilePath: zipPath.asFileURL, password: nil, progress: nil)
            try FileManager.default.removeItem(at: dbExportPath.asFileURL)
            try FileManager.default.removeItem(at: prefExportURL)
        } catch {
            Logger.debug("Can't Zip files: \(zipPath)")
        }
        return zipPath
    }
    
    func tripsFiles() -> [URL] {
        let tripsFolder = workDirectory.asNSString.appendingPathComponent(SmartReceiptsTripsDirectoryName)
        var files = [URL]()
        do {
            let trips = try FileManager.default.contentsOfDirectory(atPath: tripsFolder)
            for trip in trips {
                if trip.contains(".SMR") { continue }
                files.append(tripsFolder.asNSString.appendingPathComponent(trip).asFileURL)
            }
        } catch {
            Logger.error("appendAllTripFilesToZip error: \(error.localizedDescription)")
        }
        return files
    }
    
    var backupName:  String {
        let df = DateFormatter()
        df.dateFormat = "YYYY_MM_dd_"
        return df.string(from: Date()) + SmartReceiptsExportName
    }
    
    class func zipFiles(_ urls: [URL], to: String) throws {
        try Zip.zipFiles(paths: urls, zipFilePath: to.asFileURL, password: nil, progress: nil)
    }
}
