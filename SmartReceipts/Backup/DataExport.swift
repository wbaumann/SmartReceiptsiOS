//
//  DataExport.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import objective_zip

class DataExport: NSObject {
    var workDirectory: String!
    
    init(workDirectory: String) {
        super.init()
        self.workDirectory = workDirectory
    }
    
    func execute() -> String {
        let zipPath = (workDirectory as NSString).appendingPathComponent(backupName)
        Logger.debug("Execute at path: \(zipPath)")

        let zipFile = OZZipFile(fileName: zipPath, mode: .create)
        Logger.debug("zipFile legacy32BitMode: \(zipFile.legacy32BitMode ? "YES" : "NO")")
        
        appendFile(named: SmartReceiptsDatabaseName, inDirectory: workDirectory,
                   archiveName: SmartReceiptsDatabaseExportName, toZip: zipFile)
        appendAllTrips(toZip: zipFile)
        let preferences = WBPreferences.xmlString().data(using: .utf8)
        append(data: preferences!, zipName: SmartReceiptsPreferencesExportName, toFile: zipFile)
        zipFile.close()
        return zipPath
    }
    
    func appendFile(named fileName: String, inDirectory: String, archiveName: String, toZip: OZZipFile) {
        let filePath = (inDirectory as NSString).appendingPathComponent(fileName)
        let fileData = NSData(contentsOfFile: filePath)
        append(data: fileData! as Data, zipName: archiveName, toFile: toZip)
    }
    
    func append(data: Data, zipName: String, toFile: OZZipFile) {
        Logger.debug("Append Data: size \(data.count) zipName: \(zipName), toFile: \(toFile.description)")
        let stream = toFile.writeInZip(withName: zipName, compressionLevel: .default)
        stream.write(data)
        stream.finishedWriting()
    }
    
    func appendAllTrips(toZip file: OZZipFile) {
        let tripsFolder = (workDirectory as NSString).appendingPathComponent(SmartReceiptsTripsDirectoryName)
        
        var trips = [String]()
        do {
            trips = try FileManager.default.contentsOfDirectory(atPath: tripsFolder)
        } catch {
            Logger.error("appendAllTripFilesToZip error: \(error.localizedDescription)")
        }
        
        for trip in trips {
            appendFilesFor(trip: trip, to: file)
        }
    }
    
    func appendFilesFor(trip: String, to zip: OZZipFile) {
        let tripFolder = ((workDirectory as NSString).appendingPathComponent(SmartReceiptsTripsDirectoryName)
            as NSString).appendingPathComponent(trip)
        
        var files = [String]()
        do {
            files = try FileManager.default.contentsOfDirectory(atPath: tripFolder)
        } catch {
            Logger.error("appFilesForTrip error: \(error.localizedDescription)")
        }
        for file in files {
            let zipName = (trip as NSString).appendingPathComponent(file)
            appendFile(named: file, inDirectory: tripFolder, archiveName: zipName, toZip: zip)
        }
    }
    
    var backupName:  String {
        let df = DateFormatter()
        df.dateFormat = "YYYY_MM_dd_"
        return df.string(from: Date()) + SmartReceiptsExportName
    }
}
