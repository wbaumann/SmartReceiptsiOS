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
        let grossTotal = PricesCollection()
        let receiptTotal = PricesCollection()
        let reimbursableTotal = PricesCollection()
        let noTaxesTotal = PricesCollection()
        let taxesTotal = PricesCollection()
        let distanceTotal = PricesCollection()
        let grandTotal = PricesCollection()
        let grandTotalReimbursable = PricesCollection()
        
        let pricesPreTax = WBPreferences.enteredPricePreTax()
        let reportOnlyReimbursable = WBPreferences.onlyIncludeReimbursableReceiptsInReports()
        
        var recs = receipts()
        
        for receipt in recs {
            if reportOnlyReimbursable && !receipt.isReimbursable {
                continue
            }
            grossTotal.addPrice(receipt.targetPrice())
            receiptTotal.addPrice(receipt.targetPrice())
            noTaxesTotal.addPrice(receipt.targetPrice())
            noTaxesTotal.subtractPrice(receipt.targetTax())
            taxesTotal.addPrice(receipt.targetTax())
            grossTotal.addPrice(receipt.targetTax())
            grandTotal.addPrice(receipt.targetPrice())
            if receipt.isReimbursable {
                reimbursableTotal.addPrice(receipt.targetPrice())
            }
        }
        
        let dists = distances()
        
        for distance in dists {
            grandTotal.addPrice(distance.totalRate())
            distanceTotal.addPrice(distance.totalRate())
        }
        
        pdfRender.setTripName(trip: trip.name)
        
        let startDate = dateFormatter.formattedDate(trip.startDate, in: trip.startTimeZone)!
        let endDate = dateFormatter.formattedDate(trip.endDate, in: trip.endTimeZone)!
        pdfRender.appendHeader(row: String(format: LocalizedString("pdf.report.from.to.label.base"), startDate, endDate))
        
        if WBPreferences.trackCostCenter() && !trip.costCenter.isEmpty {
            pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.const.center.label")) \(trip.costCenter)")
        }
        
        if trip.comment != nil && !trip.comment.isEmpty {
            pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.comment.label")) \(trip.comment)")
        }
        
        // Short Code for Get: currencyFormattedPrice()
        func fp(_ p: PricesCollection) -> String { return p.currencyFormattedPrice() }
        
        if !WBPreferences.includeTaxField() && recs.count > 0 && !taxesTotal.hasValue() {
            pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.receipts.total.label")) \(fp(receiptTotal))")
        }
        
        if WBPreferences.includeTaxField() && taxesTotal.hasValue() {
            pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.receipts.total.label")) \(fp(receiptTotal))")
            pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.tax.total.label")) \(fp(taxesTotal))")
            pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.receipts.total.sans.tax.label")) \(fp(noTaxesTotal))")
        }
        
        if dists.count > 0 {
            pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.distance.total.label")) \(fp(distanceTotal))")
        }
        
        pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.grand.total.label")) \(fp(grandTotal))", style: .defaultBold)
        
        if !reportOnlyReimbursable && reimbursableTotal.hasValue() {
            let row = "\(LocalizedString("pdf.report.grand.reimbursable.total.label")) \(fp(reimbursableTotal))"
            pdfRender.appendHeader(row: row, style: .defaultBold)
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

