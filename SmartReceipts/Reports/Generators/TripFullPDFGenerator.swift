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
    
        var hasNonReimbursable = false
        
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
                if WBPreferences.enteredPricePreTax() {
                    reimbursableTotal.addPrice(tax)
                }
            } else {
                hasNonReimbursable = true
            }
        }
        
        let dists = distances()
        
        for distance in dists {
            grandTotal.addPrice(distance.totalRate())
            reimbursableTotal.addPrice(distance.totalRate())
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
        
        
        if !WBPreferences.includeTaxField() && recs.count > 0 || !taxesTotal.hasValue() {
            pdfRender.appendHeader(row: "\(LocalizedString("pdf_report_receipts_total_label")) \(fp(receiptTotal))")
        } else if WBPreferences.includeTaxField() && taxesTotal.hasValue() {
            pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.receipts.total.sans.tax.label")) \(fp(noTaxesTotal))")
            pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.tax.total.label")) \(fp(taxesTotal))")
            pdfRender.appendHeader(row: "\(LocalizedString("pdf_report_receipts_total_with_tax_label")) \(fp(receiptTotal))")
        }
        
        if dists.count > 0 {
            pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.distance.total.label")) \(fp(distanceTotal))")
        }
        
        pdfRender.appendHeader(row: "\(LocalizedString("pdf.report.grand.total.label")) \(fp(grandTotal))", style: .defaultBold)
        
        if !reportOnlyReimbursable && hasNonReimbursable {
            let row = "\(LocalizedString("pdf.report.grand.reimbursable.total.label")) \(fp(reimbursableTotal))"
            pdfRender.appendHeader(row: row, style: .defaultBold)
        }
        
        pdfRender.closeHeader()
        
        
        //MARK: Render Tables
        
        if !WBPreferences.omitDefaultPdfTable() {
            appendReportsTable()
        }

        if WBPreferences.printDistanceTable() && !dists.isEmpty {
            appendDistancesTable()
        }

        if WBPreferences.includeCategoricalSummation() {
            appendCategoricalSummationTable()
        }
        
        if WBPreferences.separatePaymantsByCategory() {
            appendSeparatedByCategoryTable()
        }
        
    }
    
    private func appendSeparatedByCategoryTable() {
        for (category, receipts) in receiptsByCategories() {
            let receiptsTable = ReportPDFTable(title: category, pdfRender: pdfRender, columns: receiptColumns())!
            receiptsTable.includeHeaders = true
            receiptsTable.includeFooters = true
            receiptsTable.append(withRows: receipts)
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

