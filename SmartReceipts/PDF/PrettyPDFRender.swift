//
//  PrettyPDFRender.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

fileprivate let MinNumberOfTableRowsForPage = 3

class PrettyPDFRender: NSObject {
    private(set) var tableHasTooManyColumns = false
    var landscapePreferred = false
    var rows = [[String]]()
    var rowToStart = 0
    var writingToPage: PDFPageView!
    var openTable: PDFReportTable!
    
    private var _header: TripReportHeader?
    var header: TripReportHeader {
        if _header == nil {
            _header = TripReportHeader.loadInstance()
        }
        return _header!
    }
    
    func setOutput(path: String) -> Bool {
        return UIGraphicsBeginPDFContextToFile(path, openPage.bounds, nil)
    }
    
    func setTripName(trip: String) {
        header.setTrip(name: trip)
    }
    
    var openPage: PDFPageView {
        if writingToPage == nil {
            startNextPage()
        }
        return writingToPage
    }
    
    func startNextPage() {
        if writingToPage != nil {
            self.renderPage(writingToPage)
        }
        let newPage = Bundle.main.loadNibNamed("PDFPage", owner: nil, options: nil)?.first as? PDFPageView
        newPage?.frame = landscapePreferred ? PDFPageView.pdfPageA4Landscape() : PDFPageView.pdfPageA4Portrait()
        newPage?.layoutIfNeeded()
        writingToPage = newPage
    }
    
    func closeHeader() {
        openPage.appendHeader(header)
    }
    
    func appendHeader(row: String, style: PDFFontStyle = .default) {
        header.appendRow(row, style: style)
    }
    
    func renderPages() -> Bool {
        // Sometimes there are no content on page. We don't render empty pages as it causes an extra page appearing
        if !openPage.isEmpty() {
            renderPage(openPage)
        } else {
            Logger.warning("prevented rendering of the empty pdf page")
        }
        UIGraphicsEndPDFContext()
        return tableHasTooManyColumns ? false : true
    }
    
    func renderPage(_ page: PDFPageView) {
        UIGraphicsBeginPDFPageWithInfo(page.bounds, nil);
        let context = UIGraphicsGetCurrentContext()
        page.layer.render(in: context!)
    }
    
    func startTable() {
        openTable = PDFReportTable.loadInstance()
        openTable.frame = CGRect(x: 0, y: 0, width: header.frame.width, height: 100)
    }
    
    func appendTable(headers: [String]) {
        openTable.columns = headers
    }
    
    func appendTable(columns: [String]) {
        openTable.append(values: columns)
    }
    
    func appendTable(footers: [String]) {
        openTable.footers = footers
    }
    
    func closeTable() {
        let fullyAddedTable = openTable.buildTable(availableSpace: openPage.remainingSpace())
        openPage.appendTable(openTable)
        
        if openTable.hasTooManyColumnsToFitWidth {
            tableHasTooManyColumns = true
        }
        if fullyAddedTable { return }
        
        let partialTable = openTable!
        let reminder = partialTable.rows.count - partialTable.rowsAdded
        if partialTable.rowToStart == 0 &&
            (partialTable.rowsAdded < MinNumberOfTableRowsForPage || reminder < MinNumberOfTableRowsForPage) {
            openTable.removeFromSuperview()
            startNextPage()
            openTable.rowToStart = partialTable.rowsAdded
            closeTable()
            return
        }
        
        startNextPage()
        startTable()
        openTable.columns = partialTable.columns
        openTable.rows = partialTable.rows
        openTable.rowToStart = partialTable.rowsAdded
        closeTable()
    }
    
    func append(image: UIImage, label: String) {
        if openPage.imageIndex == 4 {
            startNextPage()
        }
        let imageView = PDFImageView.loadInstance()!
        imageView.titleLabel.text = label
        imageView.imageView.image = image
        imageView.fitImageView()
        openPage.appendImage(imageView)
    }
    
    func appendFullPage(image: UIImage, label: String) {
        if !openPage.isEmpty() {
            startNextPage()
        }
        let imageView = FullPagePDFImageView.loadInstance()!
        imageView.titleLabel.text = label
        imageView.imageView.image = image
        imageView.fitImageView()
        openPage.appendImage(imageView)
        startNextPage()
    }
    
    func appendPDF(page: CGPDFPage, label: String) {
        if !openPage.isEmpty() {
            startNextPage()
        }
        let cropBox = page.getBoxRect(.cropBox)
        if cropBox.isEmpty || cropBox.isNull || cropBox.equalTo(CGRect.zero) {
            Logger.error("CGRectEqualToRect(cropBox, CGRectZero), label = \(label)")
        }
        let pdfPageRenderView = FullPagePDFPageView.loadInstance()!
        pdfPageRenderView.titleLabel.text = label
        pdfPageRenderView.pageRenderView.page = page
        openPage.appendFullPageElement(pdfPageRenderView)
        startNextPage()
    }
}

