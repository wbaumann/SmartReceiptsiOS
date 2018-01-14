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
        appendSummaryAndTables()

        // always render fullPageElements and images in protrait orientation
        pdfRender.landscapePreferred = false
        pdfRender.startNextPage()
        appendImages()
        return pdfRender.renderPages()
    }
    
    private func appendSummaryAndTables() {
        let receiptTotal = PricesCollection()
        let reimbursableTotal = PricesCollection()
        let noTaxesTotal = PricesCollection()
        let taxesTotal = PricesCollection()
        let distanceTotal = PricesCollection()
        let grandTotal = PricesCollection()
        let grandTotalReimbursable = PricesCollection()
        
        let pricesPreTax = WBPreferences.enteredPricePreTax()
        let reportOnlyReimbursable = WBPreferences.onlyIncludeReimbursableReceiptsInReports()
        
        let recs = receipts()
        
        for receipt in recs {
            if reportOnlyReimbursable && !receipt.isReimbursable {
                continue
            }
            let price = receipt.targetPrice()
            let tax = receipt.targetTax()
            
            receiptTotal.addPrice(price)
            taxesTotal.addPrice(tax)
            noTaxesTotal.addPrice(price)
            grandTotal.addPrice(price)
            
            if WBPreferences.enteredPricePreTax() {
                grandTotal.addPrice(tax)
                receiptTotal.addPrice(tax)
            } else {
                noTaxesTotal.subtractPrice(tax)
            }
            
            if receipt.isReimbursable {
                reimbursableTotal.addPrice(price)
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
            pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.receipts.total.sans.tax.label")) \(fp(noTaxesTotal))")
            pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.tax.total.label")) \(fp(taxesTotal))")
            pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.receipts.total.label")) \(fp(receiptTotal))")
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
        
    //Render Tables
    
        if !WBPreferences.omitDefaultPdfTable() {
            appendReportsTable()
        }
        
        if WBPreferences.printDistanceTable() && !dists.isEmpty {
            appendDistancesTable()
        }
        
        if WBPreferences.includeCategoricalSummation() {
            appendCategoricalSummationTable()
        }
        
    }
    
    private func appendReportsTable() {
        var rows = receipts()
        let receiptsTable = ReportPDFTable(pdfRender: pdfRender, columns: receiptColumns())!
        receiptsTable.includeHeaders = true
        receiptsTable.includeFooters = true
        if WBPreferences.printDailyDistanceValues() {
            let dReceipts = DistancesToReceiptsConverter.convertDistances(distances()) as! [WBReceipt]
            rows.append(contentsOf: dReceipts)
            rows.sort(by: { $1.date.compare($0.date) == .orderedAscending })
        }
        receiptsTable.append(withRows: rows)
    }
    
    private func appendDistancesTable() {
        let distancesTable = ReportPDFTable(pdfRender: pdfRender, columns: distanceColumns())!
        distancesTable.includeHeaders = true
        distancesTable.includeFooters = true
        distancesTable.append(withRows: distances())
    }
    
    private func appendCategoricalSummationTable() {
        let categoricalTable = ReportPDFTable(pdfRender: pdfRender, columns: categoryColumns())!
        categoricalTable.includeHeaders = true
        categoricalTable.includeFooters = false
        categoricalTable.append(withRows: Array(receiptsByCategories().values))
    }
    
    
}

