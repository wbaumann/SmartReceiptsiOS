//
//  DatabaseMigration15to19Tests.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 29/10/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import XCTest
@testable import SmartReceipts

private let DINNER_CATEGORY = WBCategory(name: "Dinner", code: "DINN")!
private let LUNCH_CATEGORY = WBCategory(name: "Lunch", code: "LNCH")!
private let PERSONAL_CARD = PaymentMethod(objectId: 3, method: "Personal Card")

class DatabaseMigration15to19Tests: XCTestCase {
    
    var databaseV15migrated: Database!
    var databaseV19: Database!

    override func setUp() {
        func database(name: String) -> Database {
            let path = Bundle(for: type(of: self)).path(forResource: name, ofType: "db")!
            let copyPath = NSTemporaryDirectory().asNSString.appendingPathComponent("test_\(name).db")
            do {
                FileManager.deleteIfExists(filepath: copyPath)
                try FileManager.default.copyItem(atPath: path, toPath: copyPath)
            } catch {
                XCTFail(error.localizedDescription)
            }
        
            let database = Database(databasePath: copyPath, tripsFolderPath: NSTemporaryDirectory())
            database?.open(false)
            return database!
        }
        
        databaseV15migrated = database(name: "android-receipts-v15")
        databaseV19 = database(name: "android-receipts-v19")
        
        databaseV15migrated.setNotificationsDisabled(true)
        databaseV19.setNotificationsDisabled(true)
        
        let migrations: [DatabaseMigration] = [
                DatabaseCreateAtVersion11(),
                DatabaseUpgradeToVersion12(),
                DatabaseUpgradeToVersion13(),
                DatabaseUpgradeToVersion14(),
                DatabaseUpgradeToVersion15(),
                DatabaseUpgradeToVersion16(),
                DatabaseUpgradeToVersion17(),
                DatabaseUpgradeToVersion18(),
                DatabaseUpgradeToVersion19()
        ]
        
        DatabaseMigrator().run(migrations: migrations, database: databaseV15migrated)
    }

    override func tearDown() {
        
    }
    
    func testMigration() {
        // First - confirm that we're on the latest database version
        XCTAssertEqual(databaseV15migrated.databaseVersion(), databaseV19.databaseVersion())
        
        // Next - verify each of our categories
        let categoriesV19 = databaseV19.listAllCategories()!
        let categoriesV15 = databaseV15migrated.listAllCategories()!
        
        XCTAssertEqual(categoriesV15.count, categoriesV19.count)
        
        for (index, category) in categoriesV15.enumerated() {
            let cat19 = categoriesV19[index]
            
            XCTAssertEqual(category.name, cat19.name)
            XCTAssertEqual(category.code, cat19.code)
            XCTAssertEqual(0, cat19.customOrderId)
            XCTAssertEqual(category.customOrderId, index+1)
        }
        
        
        // Next - verify each of our payment methods
        
        let paymentMethodsV19 = databaseV19.allPaymentMethods()!
        let paymentMethodsV15 = databaseV15migrated.allPaymentMethods()!
        
        XCTAssertEqual(paymentMethodsV15.count, paymentMethodsV19.count)
        
        for (index, paymentMethod) in paymentMethodsV15.enumerated() {
            let pm19 = paymentMethodsV19[index]
            
            XCTAssertEqual(paymentMethod.objectId, pm19.objectId)
            XCTAssertEqual(paymentMethod.method, pm19.method)
            XCTAssertEqual(0, pm19.customOrderId)
        }
        
        
        // Next - verify each of our CSV columns
        let csvColumnsV19 = databaseV19.allCSVColumns()! as! [ReceiptColumn]
        let csvColumnsV15 = databaseV15migrated.allCSVColumns()! as! [ReceiptColumn]
        
        XCTAssertEqual(csvColumnsV15.count, csvColumnsV19.count)
        
        for (index, column) in csvColumnsV15.enumerated() {
            let column19 = csvColumnsV19[index]
            
            XCTAssertEqual(column.сolumnType, column19.сolumnType)
            XCTAssertEqual(column.objectId, column19.objectId)
            XCTAssertEqual(0, column19.customOrderId)
        }
        
        
        // Next - verify each of our PDF columns
        
        let pdfColumnsV19 = databaseV19.allPDFColumns()! as! [ReceiptColumn]
        let pdfColumnsV15 = databaseV15migrated.allPDFColumns()! as! [ReceiptColumn]
        
        XCTAssertEqual(pdfColumnsV15.count, pdfColumnsV19.count)
        
        for (index, column) in pdfColumnsV15.enumerated() {
            let column19 = pdfColumnsV19[index]
            
            XCTAssertEqual(column.сolumnType, column19.сolumnType)
            XCTAssertEqual(column.objectId, column19.objectId)
            XCTAssertEqual(0, column19.customOrderId)
        }
        
        
        // Next - confirm each of our trips and the data within
        
        let trips = databaseV15migrated.allTrips()! as! [WBTrip]
        XCTAssertEqual(3, trips.count)
        
        // Data that we'll want to store for final comparisons
        var allReceipts: [WBReceipt] = []
        var allDistances: [Distance] = []
        
        // Receipt counters
        var lastReceiptCustomOrderId = 0
        var receiptIndexCounter = 1
        
        // Confirm the data within Report 1
        let report1 = trips[0]
        databaseV15migrated.refreshPriceForTrip(report1)
        XCTAssertEqual(1, report1.objectId)
        XCTAssertEqual("Report 1", report1.name)
        XCTAssertEqual("Report 1", report1.directoryPath().asNSString.lastPathComponent)
        XCTAssertEqual("11/16/16", WBDateFormatter().formattedDate(report1.startDate, in: report1.startTimeZone))
        XCTAssertEqual("11/20/16", WBDateFormatter().formattedDate(report1.endDate, in: report1.endTimeZone))
        XCTAssertEqual("$45.00", report1.formattedPrice())
        XCTAssertEqual("USD", report1.defaultCurrency.code)
        XCTAssertEqual("Comment", report1.comment)
        XCTAssertEqual("Cost Center", report1.costCenter)
        
        // And the receipts in report 1
        
        let recs1 = databaseV15migrated.allReceipts(for: report1) as! [WBReceipt]
        let report1Receipts = ReceiptIndexer.indexReceipts(recs1, filter: { _ in true })
        allReceipts.append(contentsOf: report1Receipts)
        report1Receipts.forEach {
            XCTAssertEqual(receiptIndexCounter++, $0.reportIndex)
            XCTAssertTrue($0.customOrderId > lastReceiptCustomOrderId) // These should be increasing for receipts
            lastReceiptCustomOrderId = $0.customOrderId
            verifyPictureReceipt($0, report1, DINNER_CATEGORY) // Note: All receipts in report 1 are of this style
        }
        
        // And the distances
        
        let report1Distances = databaseV15migrated.allDistances(for: report1) as! [Distance]
        XCTAssertTrue(report1Distances.isEmpty)
        allDistances.append(contentsOf: report1Distances)
        
        
        // Confirm the data within Report 2
        let report2 = trips[1]
        databaseV15migrated.refreshPriceForTrip(report2)
        XCTAssertEqual(2, report2.objectId)
        XCTAssertEqual("Report 2", report2.name)
        XCTAssertEqual("Report 2", report2.directoryPath().asNSString.lastPathComponent)
        XCTAssertEqual("11/17/16", WBDateFormatter().formattedDate(report2.startDate, in: report2.startTimeZone))
        XCTAssertEqual("11/20/16", WBDateFormatter().formattedDate(report2.endDate, in: report2.endTimeZone))
        XCTAssertEqual("$50.00", report2.formattedPrice())
        XCTAssertEqual("USD", report2.defaultCurrency.code)
        XCTAssertEqual("", report2.comment)
        XCTAssertEqual("", report2.costCenter)
        
        // And the receipts in report 2
        receiptIndexCounter = 1
        lastReceiptCustomOrderId = 0
        let recs2 = databaseV15migrated.allReceipts(for: report2) as! [WBReceipt]
        let report2Receipts = ReceiptIndexer.indexReceipts(recs2, filter: { _ in true })
        allReceipts.append(contentsOf: report2Receipts)
        
        report2Receipts.forEach {
            XCTAssertEqual(receiptIndexCounter++, $0.reportIndex)
            XCTAssertTrue($0.customOrderId > lastReceiptCustomOrderId) // These should be increasing for receipts
            lastReceiptCustomOrderId = $0.customOrderId
            
            switch receiptIndexCounter - 1 {
            case 1...5: verifyPictureReceipt($0, report2, DINNER_CATEGORY)
            case 6...8: verifyFullPictureReceipt($0, report2, LUNCH_CATEGORY, PERSONAL_CARD)
            default: verifyPictureReceipt($0, report2, DINNER_CATEGORY, "11/19/16")
            }
        }
        
        // And the distances
        let report2Distances = databaseV15migrated.allDistances(for: report2) as! [Distance]
        XCTAssertTrue(report2Distances.isEmpty)
        allDistances.append(contentsOf: report2Distances)
        
        // Confirm the data within Report 3
        
        let report3 = trips[2]
        databaseV15migrated.refreshPriceForTrip(report3)
        XCTAssertEqual(3, report3.objectId)
        XCTAssertEqual("Report 3", report3.name)
        XCTAssertEqual("Report 3", report3.directoryPath().asNSString.lastPathComponent)
        XCTAssertEqual("11/17/16", WBDateFormatter().formattedDate(report3.startDate, in: report3.startTimeZone))
        XCTAssertEqual("11/20/16", WBDateFormatter().formattedDate(report3.endDate, in: report3.endTimeZone))
        XCTAssertEqual("$68.60", report3.formattedPrice())
        XCTAssertEqual("USD", report3.defaultCurrency.code)
        XCTAssertEqual("", report3.comment)
        XCTAssertEqual("", report3.costCenter)
        
        // And the receipts in report 3
        receiptIndexCounter = 1
        lastReceiptCustomOrderId = 0
        let recs3 = databaseV15migrated.allReceipts(for: report3) as! [WBReceipt]
        let report3Receipts = ReceiptIndexer.indexReceipts(recs3, filter: { _ in true })
        allReceipts.append(contentsOf: report3Receipts)
        
        
        report3Receipts.forEach {
            XCTAssertEqual(receiptIndexCounter++, $0.reportIndex)
            XCTAssertTrue($0.customOrderId > lastReceiptCustomOrderId) // These should be increasing for receipts
            lastReceiptCustomOrderId = $0.customOrderId
            
            switch receiptIndexCounter - 1 {
            case 1: verifyPictureReceipt($0, report3, DINNER_CATEGORY)
            case 2: verifyFullPictureReceipt($0, report3, LUNCH_CATEGORY, PERSONAL_CARD)
            case 3: verifyPdfSampleReceipt($0, report3, DINNER_CATEGORY)
            case 4...9: verifyPictureReceipt($0, report3, DINNER_CATEGORY, "11/20/16")
            case 10: verifyTextReceipt($0, report3, LUNCH_CATEGORY)
            default: verifyPictureReceipt($0, report3, DINNER_CATEGORY, "11/20/16")
            }
        }
        
        // And the distances
        let report3Distances = databaseV15migrated.allDistances(for: report3) as! [Distance]
        XCTAssertTrue(!report3Distances.isEmpty)
        
        let distance = report3Distances[0]
        XCTAssertEqual(1, distance.objectId)
        XCTAssertEqual(report3, distance.trip)
        XCTAssertEqual("1.5", distance.rate.amount.stringValue)
        XCTAssertEqual("$3.00", distance.totalRate().currencyFormattedPrice())
        XCTAssertEqual("USD", distance.totalRate().currency.code)
        XCTAssertEqual("Location", distance.location)
        XCTAssertEqual("11/20/16", WBDateFormatter().formattedDate(distance.date, in: distance.timeZone))
        XCTAssertEqual("Comment", distance.comment)

        allDistances.append(contentsOf: report3Distances)

        // Verify that none of our items have the same uuid
        assertNoUuidsAreEqual(categoriesV15)
        assertNoUuidsAreEqual(paymentMethodsV15)
        assertNoUuidsAreEqual(csvColumnsV15)
        assertNoUuidsAreEqual(pdfColumnsV15)
        assertNoUuidsAreEqual(trips)
        assertNoUuidsAreEqual(allReceipts)
        assertNoUuidsAreEqual(allDistances)
        
        // Verify that our receipts don't point to the same file
        assertNoFilesAreEqual(allReceipts)
        
    }
    
    private func verifyColumns(_ column: ReceiptColumn, _ id: Int, _ type: Int, _ customOrderId: Int) {
        XCTAssertEqual(id, column.objectId)
        XCTAssertEqual(type, column.сolumnType)
        XCTAssertEqual(customOrderId, column.customOrderId)
    }

    private func verifyPictureReceipt(_ receipt: WBReceipt, _ parent: WBTrip, _ category: WBCategory, _ date: String = "11/17/16") {
        XCTAssertEqual(parent, receipt.trip)
        XCTAssertEqual("Picture", receipt.name)
        XCTAssertTrue(receipt.hasFile(for: receipt.trip))
        XCTAssertTrue(receipt.hasImage())
        XCTAssertFalse(receipt.hasPDF())
        XCTAssertTrue(receipt.imageFileName().hasSuffix("_Picture.jpg"))
        XCTAssertEqual("$5.00", receipt.price().currencyFormattedPrice())
        XCTAssertEqual("USD", receipt.price().currency.code)
        XCTAssertEqual("$0.00", receipt.tax()!.currencyFormattedPrice())
        XCTAssertEqual("USD", receipt.tax()?.currency.code)
        XCTAssertEqual(date, WBDateFormatter().formattedDate(receipt.date, in: receipt.timeZone))
        XCTAssertEqual(category.name, receipt.category!.name)
        XCTAssertEqual("", receipt.comment)
        XCTAssertNil(receipt.paymentMethod)
        XCTAssertTrue(receipt.isReimbursable)
        XCTAssertFalse(receipt.isFullPage)
    }

    private func verifyFullPictureReceipt(_ receipt: WBReceipt, _ parent: WBTrip, _ category: WBCategory, _ paymentMethod: PaymentMethod, _ date: String = "11/18/16") {
        XCTAssertEqual(parent, receipt.trip)
        XCTAssertTrue(receipt.hasFile(for: receipt.trip))
        XCTAssertTrue(receipt.hasImage())
        XCTAssertFalse(receipt.hasPDF())
        XCTAssertTrue(receipt.imageFileName().hasSuffix("_Full picture.jpg"))
        XCTAssertEqual("Full picture", receipt.name)
        XCTAssertEqual("$5.00", receipt.price().currencyFormattedPrice())
        XCTAssertEqual("USD", receipt.price().currency.code)
        XCTAssertEqual("$1.50", receipt.tax()!.currencyFormattedPrice())
        XCTAssertEqual("USD", receipt.tax()!.currency.code)
        XCTAssertEqual(date, WBDateFormatter().formattedDate(receipt.date, in: receipt.timeZone))
        XCTAssertEqual(category.objectId, receipt.category?.objectId)
        XCTAssertEqual("", receipt.comment)
        XCTAssertEqual(paymentMethod, receipt.paymentMethod)
        XCTAssertTrue(receipt.isReimbursable)
        XCTAssertTrue(receipt.isFullPage)
    }

    private func verifyPdfSampleReceipt(_ receipt: WBReceipt, _ parent: WBTrip, _ category: WBCategory,_ date: String = "11/19/16") {
        XCTAssertEqual(parent, receipt.trip)
        XCTAssertTrue(receipt.hasFile(for: receipt.trip))
        XCTAssertFalse(receipt.hasImage())
        XCTAssertTrue(receipt.hasPDF())
        XCTAssertEqual("3_Pdf sample.pdf", receipt.imageFileName())
        XCTAssertEqual("Pdf sample", receipt.name)
        XCTAssertEqual("$2.00", receipt.price().currencyFormattedPrice())
        XCTAssertEqual("USD", receipt.price().currency.code)
        XCTAssertEqual("$0.00", receipt.tax()!.currencyFormattedPrice())
        XCTAssertEqual("USD", receipt.tax()!.currency.code)
        XCTAssertEqual(date, WBDateFormatter().formattedDate(receipt.date, in: receipt.timeZone))
        XCTAssertEqual(category.objectId, receipt.category?.objectId)
        XCTAssertEqual("", receipt.comment)
        XCTAssertNil(receipt.paymentMethod)
        XCTAssertFalse(receipt.isReimbursable)
        XCTAssertFalse(receipt.isFullPage)
    }

    private func verifyTextReceipt(_ receipt: WBReceipt, _ parent: WBTrip, _ category: WBCategory) {
        XCTAssertEqual(parent, receipt.trip)
        XCTAssertTrue(receipt.hasFile(for: receipt.trip))
        XCTAssertFalse(receipt.hasImage())
        XCTAssertFalse(receipt.hasPDF())
        XCTAssertEqual("Text", receipt.name)
        XCTAssertEqual("€13.30", receipt.price().currencyFormattedPrice())
        XCTAssertEqual("EUR", receipt.price().currency.code)
        XCTAssertEqual("€13.30", receipt.price().currencyFormattedPrice())
        XCTAssertEqual("€0.00", receipt.tax()!.currencyFormattedPrice())
        XCTAssertEqual("EUR", receipt.exchangedPrice()?.currency.code)
        XCTAssertEqual("2.000000", receipt.exchangedPrice()?.currencyFormattedPrice())
        XCTAssertEqual("EUR", receipt.tax()!.currency.code)
        XCTAssertEqual(category.objectId, receipt.category?.objectId)
        XCTAssertEqual("Comment", receipt.comment)
        XCTAssertNil(receipt.paymentMethod)
        XCTAssertTrue(receipt.isReimbursable)
        XCTAssertFalse(receipt.isFullPage)
    }
    
    private func assertNoUuidsAreEqual(_ models: [FetchedModel]) {
        models.forEach { model in
            models.filter { !$0.isEqual(model) }
                .forEach { XCTAssertNotEqual(model.uuid, $0.uuid) }
        }
    }
    
    private func assertNoFilesAreEqual(_ models: [WBReceipt]) {
        models.forEach { model in
            models.filter { !$0.isEqual(model) }
                .forEach { XCTAssertNotEqual(model.imageFileName(), $0.imageFileName()) }
        }
    }
    

}
