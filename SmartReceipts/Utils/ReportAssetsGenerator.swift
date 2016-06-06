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
    private let trip: WBTrip
    private var generate: Generation!
    
    init(trip: WBTrip) {
        self.trip = trip
    }
    
    func setGenerated(fullPDF: Bool, imagesPDF: Bool, csv: Bool, imagesZip: Bool) {
        generate = Generation(fullPDF: fullPDF, imagesPDF: imagesPDF, csv: csv, imagesZip: imagesZip)
    }
    
    func generate(completion: ([String]?) -> ()) {
        trip.createDirectoryIfNotExists()
        
        let pdfPath = trip.fileInDirectoryPath("\(trip.name).pdf")
        let pdfImagesPath = trip.fileInDirectoryPath("\(trip.name)Images.pdf")
        let csvPath = trip.fileInDirectoryPath("\(trip.name).csv")
        let zipPath = trip.fileInDirectoryPath("\(trip.name).zip")
        
        var files = [String]()
        
        if generate.fullPDF {
            clearPath(pdfPath)
            let generator = TripFullPDFGenerator(trip: trip, database: Database.sharedInstance())
            if generator.generateToPath(pdfPath) {
                files.append(pdfPath)
            } else {
                completion(nil)
                return
            }
        }
        
        if generate.imagesPDF {
            clearPath(pdfImagesPath)
            let generator = TripImagesPDFGenerator(trip: trip, database: Database.sharedInstance())
            if generator.generateToPath(pdfImagesPath) {
                files.append(pdfImagesPath)
            } else {
                completion(nil)
                return
            }
        }
        
        if generate.csv {
            clearPath(csvPath)
            let generator = TripCSVGenerator(trip: trip, database: Database.sharedInstance())
            if generator.generateToPath(csvPath) {
                files.append(csvPath)
            } else {
                completion(nil)
                return
            }
        }
        
        if generate.imagesZip {
            clearPath(zipPath)
            
            let rai = WBReceiptAndIndex.receiptsAndIndicesFromReceipts(Database.sharedInstance().allReceiptsForTrip(trip), filteredWith: {
                receipt in
                
                return WBReportUtils.filterOutReceipt(receipt)
            })
            
            let stamper = WBImageStampler()
            if stamper.zipToFile(zipPath, stampedImagesForReceiptsAndIndexes: rai, inTrip: trip) {
                files.append(zipPath)
            } else {
                completion(nil)
                return
            }
        }

        completion(files)
    }
    
    private func clearPath(path: String) {
        if !NSFileManager.defaultManager().fileExistsAtPath(path) {
            return
        }

        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
        } catch let error as NSError {
            Log.error("Remove file error \(error)")
        }
    }
}