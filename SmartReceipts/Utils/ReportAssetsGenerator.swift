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
        Logger.info("setGenerated: \(generate)")
    }
    
    /// Generate reports
    ///
    /// - Parameter completion: [String] - array of resulting files (paths), GeneratorError - optional error
    func generate(onSuccessHandler: ([String]) -> (), onErrorHandler: (GeneratorError) -> ()) {
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
            guard let generator = TripFullPDFGenerator(trip: trip, database: db) else {
                onErrorHandler(.fullPdfFailed)
                return
            }
            
            if generator.generate(toPath: pdfPath) {
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
            guard let generator = TripImagesPDFGenerator(trip: trip, database:db) else {
                onErrorHandler(.imagesPdf)
                return
            }
            if generator.generate(toPath: pdfImagesPath) {
                files.append(pdfImagesPath!)
            } else {
                onErrorHandler(.imagesPdf)
                return
            }
        }
        
        if generate.csv {
            Logger.info("generate.csv")
            clearPath(csvPath!)
            guard let generator = TripCSVGenerator(trip: trip, database: db) else {
                onErrorHandler(.csvFailed)
                return
            }
            
            if generator.generate(toPath: csvPath) {
                files.append(csvPath!)
            } else {
                onErrorHandler(.csvFailed)
                return
            }
        }
        
        if generate.imagesZip {
            Logger.info("generate.imagesZip")
            clearPath(zipPath!)
            
            let rai = WBReceiptAndIndex.receiptsAndIndices(fromReceipts: db?.allReceipts(for: trip), filteredWith: {  receipt in
                return WBReportUtils.filterOutReceipt(receipt)
            })
            
            let stamper = WBImageStampler()
            if stamper.zip(toFile: zipPath, stampedImagesForReceiptsAndIndexes: rai, in: trip) {
                files.append(zipPath!)
            } else {
                onErrorHandler(.zipImagesFailed)
                return
            }
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
