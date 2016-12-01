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
    fileprivate let trip: WBTrip
    fileprivate var generate: Generation!
    
    init(trip: WBTrip) {
        self.trip = trip
    }
    
    func setGenerated(_ fullPDF: Bool, imagesPDF: Bool, csv: Bool, imagesZip: Bool) {
        generate = Generation(fullPDF: fullPDF, imagesPDF: imagesPDF, csv: csv, imagesZip: imagesZip)
    }
    
    func generate(_ completion: ([String]?) -> ()) {
        trip.createDirectoryIfNotExists()
        
        
        let tripName = trip.name ?? "Report" // force unwrapping isn't good practice
        let pdfPath = trip.file(inDirectoryPath: "\(tripName).pdf")
        let pdfImagesPath = trip.file(inDirectoryPath: "\(tripName)Images.pdf")
        let csvPath = trip.file(inDirectoryPath: "\(tripName).csv")
        let zipPath = trip.file(inDirectoryPath: "\(tripName).zip")
        
        var files = [String]()
        
        if generate.fullPDF {
            clearPath(pdfPath!)
            let generator = TripFullPDFGenerator(trip: trip, database: Database.sharedInstance())
            if (generator?.generate(toPath: pdfPath))! {
                files.append(pdfPath!)
            } else {
                completion(nil)
                return
            }
        }
        
        if generate.imagesPDF {
            clearPath(pdfImagesPath!)
            let generator = TripImagesPDFGenerator(trip: trip, database: Database.sharedInstance())
            if (generator?.generate(toPath: pdfImagesPath))! {
                files.append(pdfImagesPath!)
            } else {
                completion(nil)
                return
            }
        }
        
        if generate.csv {
            clearPath(csvPath!)
            let generator = TripCSVGenerator(trip: trip, database: Database.sharedInstance())
            if (generator?.generate(toPath: csvPath))! {
                files.append(csvPath!)
            } else {
                completion(nil)
                return
            }
        }
        
        if generate.imagesZip {
            clearPath(zipPath!)
            
            let rai = WBReceiptAndIndex.receiptsAndIndices(fromReceipts: Database.sharedInstance().allReceipts(for: trip), filteredWith: {
                receipt in
                
                return WBReportUtils.filterOutReceipt(receipt)
            })
            
            let stamper = WBImageStampler()
            if stamper.zip(toFile: zipPath, stampedImagesForReceiptsAndIndexes: rai, in: trip) {
                files.append(zipPath!)
            } else {
                completion(nil)
                return
            }
        }

        completion(files)
    }
    
    fileprivate func clearPath(_ path: String) {
        if !FileManager.default.fileExists(atPath: path) {
            return
        }

        do {
            try FileManager.default.removeItem(atPath: path)
        } catch let error as NSError {
            Log.error("Remove file error \(error)")
        }
    }
}
