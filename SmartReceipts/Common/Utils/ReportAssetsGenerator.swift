//
//  ReportAssetsGenerator.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 06/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

class ReportAssetsGenerator: NSObject {
    
    // Generator's error representation
    enum GeneratorError {
        case fullPdfFailed          // error in general
        case fullPdfTooManyColumns  // can't place all PDF columns
        case imagesPdf
        case csvFailed
        case zipFilesFailed
        case zipImagesFailed
    }
    
    private let trip: WBTrip
    private let generate: GenerateReportSelection
    
    init(trip: WBTrip, generate: GenerateReportSelection) {
        self.trip = trip
        self.generate = generate
        Logger.info("Generate: \(String(describing: generate))")
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
        let pdfImagesPath = trip.file(inDirectoryPath: "\(tripName)_images.pdf")
        let csvPath = trip.file(inDirectoryPath: "\(tripName).csv")
        let zipPath = trip.file(inDirectoryPath: "\(tripName).zip")
        
        if generate.fullPdfReport {
            Logger.info("generate.fullPDF")
            clearPath(pdfPath!)
            let generator = TripFullPDFGenerator(trip: trip, database: db)
            
            if generator.generateTo(path: pdfPath!) {
                files.append(pdfPath!)
            } else {
                let error: GeneratorError = generator.pdfRender.tableHasTooManyColumns ? .fullPdfTooManyColumns : .fullPdfFailed
                onErrorHandler(error)
                return
            }
        }
        
        if generate.pdfReportWithoutTable {
            Logger.info("generate.imagesPDF")
            clearPath(pdfImagesPath!)
            let generator = TripImagesPDFGenerator(trip: trip, database: db)
            if generator.generateTo(path: pdfImagesPath!) {
                files.append(pdfImagesPath!)
            } else {
                onErrorHandler(.imagesPdf)
                return
            }
        }
        
        if generate.csvFile {
            Logger.info("generate.csv")
            clearPath(csvPath!)
            let generator = TripCSVGenerator(trip: trip, database: db)
            if generator.generateTo(path: csvPath!) {
                files.append(csvPath!)
            } else {
                onErrorHandler(.csvFailed)
                return
            }
        }
        
        if generate.zipFiles {
            Logger.info("generate.filesZip")
            clearPath(zipPath!)
            
            do { try DataExport.zipFiles(reportUrls(), to: zipPath!) }
            catch { onErrorHandler(.zipImagesFailed); return }
            files.append(zipPath!)
        }
        
        if generate.zipStampedJPGs {
            Logger.info("generate.imagesZip")
            let path = generate.zipFiles ? zipPath?.replacingOccurrences(of: ".zip", with: "_stamped.zip") : zipPath
            clearPath(path!)
            
            let reportURLs = reportUrls()
            let result = WBImageStampler().stampImages(forReceipts: receipts(), in: trip) { urls in
                let files = Array(Set(urls.adding(reportURLs)))
                do { try DataExport.zipFiles(files, to: path!) }
                catch { onErrorHandler(.zipImagesFailed); return }
            }
            
            guard result else { return }
            files.append(path!)
        }

        onSuccessHandler(files)
    }
    
    private func reportUrls() -> [URL] {
        let urls = receipts()
            .filter { $0.hasFile(for: trip) }
            .compactMap { $0.imageFilePath(for: trip) }
            .map { URL(fileURLWithPath: $0) }
        
        return urls
    }
    
    private func receipts() -> [WBReceipt] {
        let db = Database.sharedInstance()
        return WBReceiptAndIndex
            .receiptsAndIndices(fromReceipts: db.allReceipts(for: trip), filteredWith: {  WBReportUtils.filterOutReceipt($0) })!
            .compactMap { ($0 as? WBReceiptAndIndex)?.receipt() }
    }
    
    private func clearPath(_ path: String) {
        guard FileManager.default.fileExists(atPath: path) else { return }

        do {
            try FileManager.default.removeItem(atPath: path)
        } catch let error as NSError {
            let errorEvent = ErrorEvent(error: error)
            AnalyticsManager.sharedManager.record(event: errorEvent)
            Logger.error("Remove file error \(error)")
        }
    }
}
