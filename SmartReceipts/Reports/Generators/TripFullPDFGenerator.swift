//
//  TripFullPDFGenerator.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class TripFullPDFGenerator: TripImagesPDFGenerator {
    override func generateTo(path: String) -> Bool {
        // render tables in landscape orientation if needed
        pdfRender.landscapePreferred = WBPreferences.printReceiptTableLandscape()
        
        if !pdfRender.setOutput(path: path) { return false }
        appenSummaryAndTables()

        // always render fullPageElements and images in protrait orientation
        pdfRender.landscapePreferred = false
        pdfRender.startNextPage()
        appendImages()
        return pdfRender.renderPages()
    }
    
    private func appenSummaryAndTables() {
        let netTotal = PricesCollection()
        let receiptTotal = PricesCollection()
        let reimbursableTotal = PricesCollection()
        let noTaxesTotal = PricesCollection()
        let taxesTotal = PricesCollection()
        let distanceTotal = PricesCollection()
        
        let pricesPreTax = WBPreferences.enteredPricePreTax()
        let reportOnlyReimbursable = WBPreferences.onlyIncludeReimbursableReceiptsInReports()
        
        var recs = receipts()
        
        for receipt in recs {
            if reportOnlyReimbursable && !receipt.isReimbursable {
                continue
            }
            netTotal.addPrice(receipt.targetPrice())
            receiptTotal.addPrice(receipt.targetPrice())
            noTaxesTotal.addPrice(receipt.targetPrice())
            noTaxesTotal.subtractPrice(receipt.targetPrice())
            taxesTotal.addPrice(receipt.targetPrice())
            if pricesPreTax {
                netTotal.addPrice(receipt.targetPrice())
            }
            if receipt.isReimbursable {
                reimbursableTotal.addPrice(receipt.targetPrice())
            }
        }
        
        let dists = distances()
        
        for distance in dists {
            netTotal.addPrice(distance.totalRate())
            distanceTotal.addPrice(distance.totalRate())
        }
        
        pdfRender.setTripName(trip: trip.name)
        
        // Short Code for Get: currencyFormattedPrice()
        func fp(_ p: PricesCollection) -> String { return p.currencyFormattedPrice() }
        
        if !receiptTotal.isEqual(netTotal) {
            pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.receipts.total.label")) \(fp(receiptTotal))")
        }
        
        if WBPreferences.includeTaxField() {
            if pricesPreTax && taxesTotal.hasValue() {
                pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.tax.total.label")) \(fp(taxesTotal))")
            } else if !noTaxesTotal.isEqual(receiptTotal) && noTaxesTotal.hasValue() {
                pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.receipts.total.sans.tax.label")) \(fp(noTaxesTotal))")
            }
        }
        
        if !reportOnlyReimbursable && !reimbursableTotal.isEqual(receiptTotal) {
            pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.receipts.total.reimbursable.label")) \(fp(reimbursableTotal))")
        }
        
        if dists.count > 0 {
            pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.distance.total.label")) \(fp(distanceTotal))")
        }
        
        pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.gross.total.label")) \(fp(netTotal))")
        
        let startDate = dateFormatter.formattedDate(trip.startDate, in: trip.startTimeZone)!
        let endDate = dateFormatter.formattedDate(trip.endDate, in: trip.endTimeZone)!
        pdfRender.appendHeader(row: String(format: LocalizedString("pdf.report.from.to.label.base"), startDate, endDate))
        
        if WBPreferences.trackCostCenter() && !trip.costCenter.isEmpty {
            pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.const.center.label")) \(trip.costCenter)")
        }
        
        if trip.comment != nil && !trip.comment.isEmpty {
            pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.comment.label")) \(trip.comment)")
        }
        
        if dists.count > 0 {
            let totalTraveled = database.totalDistanceTraveled(for: trip).floatValue
            pdfRender.appendHeader(row: String(format: LocalizedString("pdf.report.distance.traveled.label.base"), totalTraveled))
        }
        
        pdfRender.closeHeader()
    
        let receiptsTable = ReportPDFTable(pdfRender: pdfRender, columns: receiptColumns())!
        receiptsTable.includeHeaders = true
        if WBPreferences.printDailyDistanceValues() {
            let dReceipts = DistancesToReceiptsConverter.convertDistances(distances()) as! [WBReceipt]
            recs.append(contentsOf: dReceipts)
            recs.sort(by: { $1.date.compare($0.date) == .orderedAscending })
        }
        receiptsTable.append(withRows: recs)
        
        if !WBPreferences.printDistanceTable() || dists.isEmpty { return }
        let distancesTable = ReportPDFTable(pdfRender: pdfRender, columns: distanceColumns())!
        distancesTable.includeHeaders = true
        distancesTable.append(withRows: dists)
    }
}

