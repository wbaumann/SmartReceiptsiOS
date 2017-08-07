//
//  FileManager+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 31/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

extension FileManager {
    
    class var documentsPath: String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        Logger.info("documentPaths: \(paths)")
        return paths.first!
    }
    
    class var tripsDirectoryPath: String {
        return FileManager.pathInDocuments(relativePath: SmartReceiptsTripsDirectoryName)
    }
    
    class func pathInDocuments(relativePath: String) -> String {
        return (FileManager.documentsPath as NSString).appendingPathComponent(relativePath)
    }
    
    class func initTripsDirectory() -> Bool {
        return FileManager.createDirectiryIfNotExists(path: FileManager.tripsDirectoryPath)
    }
    
    class func pathInDocumentsExists(path: String) -> Bool {
        return FileManager.default.fileExists(atPath: FileManager.pathInDocuments(relativePath: path))
    }
    
    class func createDirectiryIfNotExists(path: String) -> Bool {
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            Logger.error("Couldn't create directory: \(error.localizedDescription)")
            return false
        }
    }
    
    class func prepareDirForForceFile(newFile: String) {
        do {
            if FileManager.default.fileExists(atPath: newFile) {
                try FileManager.default.removeItem(atPath: newFile)
            }
            
            let dir = (newFile as NSString).deletingLastPathComponent
            if !FileManager.default.fileExists(atPath: dir) {
                try FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            Logger.error("Couldn't create directory: \(error.localizedDescription)")
        }
    }
    
    class func deleteIfExists(filepath: String) {
        do {
            if FileManager.default.fileExists(atPath: filepath) {
                try FileManager.default.removeItem(atPath: filepath)
            }
        } catch {
            Logger.error("Couldn't remove file: \(error.localizedDescription)")
        }
    }
    
    class func forceWrite(data: Data, to newFile: String) -> Bool {
        FileManager.prepareDirForForceFile(newFile: newFile)
        if !(data as NSData).write(toFile: newFile, atomically: true) {
            Logger.error("Failed to write data to file")
            return false
        }
        return true
    }

    class func forceCopy(from oldFile: String, to newFile: String) -> Bool {
        FileManager.prepareDirForForceFile(newFile: newFile)
        do {
            try FileManager.default.copyItem(atPath: oldFile, toPath: newFile)
            return true
        } catch {
            Logger.error("Failed to write data to file")
            return false
        }
    }
}
