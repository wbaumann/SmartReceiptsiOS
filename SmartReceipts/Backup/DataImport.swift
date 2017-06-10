//
//  DataImport.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import objective_zip

class DataImport: NSObject {
    
    var inputPath: String!
    var outputPath: String!
    
    init(inputFile: String, output: String) {
        super.init()
        self.inputPath = inputFile
        self.outputPath = output
    }
    
    func execute() {
        do {
            try FileManager.default.createDirectory(atPath: outputPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            Logger.error("execute(), error creating directory at path: \(outputPath), error: \(error.localizedDescription)")
        }
        let zipFile = OZZipFile(fileName: inputPath, mode: .unzip)
        let toFile = (outputPath as NSString).appendingPathComponent(SmartReceiptsDatabaseExportName)
        extractFrom(zip: zipFile, zipName: SmartReceiptsDatabaseExportName, toFile: toFile)
        let preferences = extractDataFrom(zipFile: zipFile, fileName: SmartReceiptsPreferencesExportName)
        WBPreferences.setFromXmlString(String(data: preferences!, encoding: .utf8))
        
        // Trips contents
        zipFile.goToFirstFileInZip()
        
        repeat {
            let info = zipFile.getCurrentFileInZipInfo()
            let name = info.name
            if name == SmartReceiptsDatabaseExportName || name.hasPrefix("shared_prefs/") {
                continue
            }
            
            let components = (name as NSString).pathComponents
            if components.count != 2 {
                continue
            }
            
            let tripName = components[0]
            let fileName = components[1]
            
            Logger.debug("Extract file for trip: \(tripName)")
            let tripPath = ((outputPath as NSString).appendingPathComponent(SmartReceiptsTripsDirectoryName)
                as NSString).appendingPathComponent(tripName)
            try? FileManager.default.createDirectory(atPath: tripPath, withIntermediateDirectories: true, attributes: nil)
            let filePath = (tripPath as NSString).appendingPathComponent(fileName)
            let stream = zipFile.readCurrentFileInZip()
            writeDataFrom(stream: stream, toFile: filePath)
        } while zipFile.goToNextFileInZip()
    }
    
    func extractFrom(zip: OZZipFile, zipName: String, toFile: String) {
        Logger.debug("Extract file named: \(zipName)")
        let found = zip.locateFile(inZip: zipName)
        if (!found) {
            Logger.warning("File with name \(zipName) not in zip")
            return;
        }
        let stream = zip.readCurrentFileInZip()
        writeDataFrom(stream: stream, toFile: toFile)
    }
    
    func writeDataFrom(stream: OZZipReadStream, toFile: String) {
        let buffer = NSMutableData(length: 8 * 1024)!
        let resultData = NSMutableData()
        var len = stream.readData(withBuffer: buffer)
        while len > 0 {
            resultData.append(buffer.mutableBytes, length: Int(len))
            len = stream.readData(withBuffer: buffer)
        }
        stream.finishedReading()
        
        Logger.debug("File size \(resultData.length)")
        WBFileManager.forceWrite(resultData as Data, to: toFile)
        Logger.debug("Written to \(toFile)")
    }
    
    func extractDataFrom(zipFile: OZZipFile, fileName: String) -> Data? {
        let tempFile = (NSTemporaryDirectory() as NSString).appendingPathComponent("extract")
        extractFrom(zip: zipFile, zipName: fileName, toFile: tempFile)
        let data = NSData(contentsOfFile: tempFile)
        try? FileManager.default.removeItem(atPath: tempFile)
        return data as Data?
    }
}
