//
//  ReportAssetsGenerator.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 06/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

private struct Generation {
    let fullPDF: Bool
    let imagesPDF: Bool
    let csv: Bool
    let imagesZip: Bool
}

class ReportAssetsGenerator: NSObject {
    
    // Generator's error representation
    enum GeneratorError {
        case fullPdfFailed          // error in general
        case fullPdfTooManyColumns  // can't place all PDF columns
        case imagesPdf
        case csvFailed
        case zipImagesFailed
    }
    
    fileprivate let trip: WBTrip
    fileprivate var generate: Generation!
    
    init(trip: WBTrip) {
        self.trip = trip
    }
    
    func setGenerated(_ fullPDF: Bool, imagesPDF: Bool, csv: Bool, imagesZip: Bool) {
        generate = Generation(fullPDF: fullPDF, imagesPDF: imagesPDF, csv: csv, imagesZip: imagesZip)
        Logger.info("setGenerated: \(String(describing: generate))")
    }
    
    /// Generate reports
    ///
    /// - Parameter completion: [String] - array of resulting files (paths), GeneratorError - optional error
    func generate(onSuccessHandler: ([String]) -> (), onErrorHandler: @escaping (GeneratorError) -> ()) {
        var files = [String]()
        let db = Database.sharedInstance()
        
        trip.createDirectoryIfNotExists()
        
        let tripName = trip.name ?? "Report"
        let pdfPath = trip.file(inDirectoryPath: "\(tripName).pdf")
        let pdfImagesPath = trip.file(inDirectoryPath: "\(tripName)Images.pdf")
        let csvPath = trip.file(inDirectoryPath: "\(tripName).csv")
        let zipPath = trip.file(inDirectoryPath: "\(tripName).zip")
        
        if generate.fullPDF {
            Logger.info("generate.fullPDF")
            clearPath(pdfPath!)
            let generator = TripFullPDFGenerator(trip: trip, database: db!)
            
            if generator.generateTo(path: pdfPath!) {
                files.append(pdfPath!)
            } else {
                if generator.pdfRender.tableHasTooManyColumns {
                    onErrorHandler(.fullPdfTooManyColumns)
                } else {
                    onErrorHandler(.fullPdfFailed)
                }
            
                return
            }
        }
        
        if generate.imagesPDF {
            Logger.info("generate.imagesPDF")
            clearPath(pdfImagesPath!)
            let generator = TripImagesPDFGenerator(trip: trip, database: db!)
            if generator.generateTo(path: pdfImagesPath!) {
                files.append(pdfImagesPath!)
            } else {
                onErrorHandler(.imagesPdf)
                return
            }
        }
        
        if generate.csv {
            Logger.info("generate.csv")
            clearPath(csvPath!)
            let generator = TripCSVGenerator(trip: trip, database: db!)
            if generator.generateTo(path: csvPath!) {
                files.append(csvPath!)
            } else {
                onErrorHandler(.csvFailed)
                return
            }
        }
        
        if generate.imagesZip {
            Logger.info("generate.imagesZip")
            clearPath(zipPath!)
            
            let receipts = WBReceiptAndIndex
                .receiptsAndIndices(fromReceipts: db?.allReceipts(for: trip), filteredWith: {  WBReportUtils.filterOutReceipt($0) })!
                .compactMap { ($0 as! WBReceiptAndIndex).receipt() }
            
            let pdfUrls = receipts
                .filter { $0.hasPDF()}
                .compactMap { $0.imageFilePath(for: trip) }
                .map { URL(fileURLWithPath: $0) }
            
            let result = WBImageStampler().stampImages(forReceipts: receipts, in: trip) { urls in
                let files = urls.adding(pdfUrls)
                do { try DataExport.zipFiles(files, to: zipPath!) }
                catch { onErrorHandler(.zipImagesFailed) }
            }
            
            guard result else { return }
            files.append(zipPath!)
        }

        onSuccessHandler(files)
    }
    
    fileprivate func clearPath(_ path: String) {
        if !FileManager.default.fileExists(atPath: path) {
            return
        }

        do {
            try FileManager.default.removeItem(atPath: path)
        } catch let error as NSError {
            let errorEvent = ErrorEvent(error: error)
            AnalyticsManager.sharedManager.record(event: errorEvent)
            Logger.error("Remove file error \(error)")
        }
    }
}
