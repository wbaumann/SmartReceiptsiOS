//
//  TripImagesPDFGenerator.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class TripImagesPDFGenerator: ReportPDFGenerator {
    private(set) var dateFormatter: WBDateFormatter!
    private(set) var pdfRender: PrettyPDFRender!

    override init(trip: WBTrip, database: Database) {
        super.init(trip: trip, database: database)
        self.dateFormatter = WBDateFormatter()
        self.pdfRender = PrettyPDFRender()
    }
    
    override func generateTo(path: String) -> Bool {
        if !pdfRender.setOutput(path: path) {
            Logger.warning("GenerateToPath returned false. Path: \(path)")
            return false
        }
        appendImages()
        return pdfRender.renderPages()
    }
    
    func appendImages() {
        fillPdfWithImagesUsing(receipts: receipts())
    }
    
    private func fillPdfWithImagesUsing(receipts: [WBReceipt]) {
        for receipt in receipts {
            if receipt.isFullPage || receipt.hasPDFFileName() {
                drawFullPage(receipt: receipt)
            } else if receipt.hasImage() {
                if let img = UIImage(contentsOfFile: receipt.imageFilePath(for: receipt.trip)) {
                    pdfRender.append(image: img, label: labelForReceipt(receipt))
                } else {
                    Logger.warning("fillPdfWithImagesUsing: Receipt-\(receipt.name) hasImage=TRUE, but no image")
                }
            }
        }
    }
    
    private func labelForReceipt(_ receipt: WBReceipt) -> String {
        let photoLabel = NSMutableString()
        let usedID = WBPreferences.printReceiptIDByPhoto() ? Int(receipt.objectId) : receipt.reportIndex
        photoLabel.append("\(usedID)")
        photoLabel.append(" • \(receipt.name)")
        photoLabel.append(" • \(dateFormatter.formattedDate(receipt.date, in: receipt.timeZone)!)")
        if WBPreferences.printCommentByPhoto() && !receipt.comment.isEmpty {
            photoLabel.append(" • \(receipt.comment)")
        }
        return photoLabel as String
    }
    
    private func drawFullPage(receipt: WBReceipt) {
        if receipt.hasImage() {
            if let image = UIImage(contentsOfFile: receipt.imageFilePath(for: receipt.trip)) {
                pdfRender.append(image: image, label: labelForReceipt(receipt))
            } else {
                Logger.warning("drawFullPageReceipt: Receipt-\(receipt.name) hasImage=TRUE, but no image")
            }
        } else if receipt.hasPDF() {
            drawFullPagePDFFile(path: receipt.imageFilePath(for: receipt.trip), label: labelForReceipt(receipt))
        } else {
            Logger.warning("drawFullPageReceipt: Receipt-\(receipt.name) hasImage && hasPDF = FLASE")
        }
    }
    private func drawFullPagePDFFile(path: String, label: String) {
        let url = URL(fileURLWithPath: path)
        guard let pdf = CGPDFDocument(url as CFURL) else {
            Logger.error("drawFullPagePDFFile: pdf is nil, for path: \(path)")
            return
        }
        
        let numberOfPages = pdf.numberOfPages
        if numberOfPages > 10 {
            Logger.warning("Too many pages \(numberOfPages) for \(label)")
        }
        for i in 0..<numberOfPages {
            let page = pdf.page(at: i + 1)
            pdfRender.appendPDF(page: page!, label: label)
        }
    }
}

