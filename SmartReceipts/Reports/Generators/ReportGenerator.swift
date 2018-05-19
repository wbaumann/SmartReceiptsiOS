//
//  ReportGenerator.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class ReportGenerator: NSObject {
    private(set) var trip: WBTrip!
    private(set) var database: Database!
    
    init(trip: WBTrip, database: Database) {
        self.trip = trip
        self.database = database
    }

    func generateTo(path: String) -> Bool {
        abstractMethodError()
        return false
    }
    
    func receiptColumns() -> [ReceiptColumn] {
        abstractMethodError()
        return []
    }
    
    func categoryColumns() -> [CategoryColumn] {
        return CategoryColumn.allColumns()
    }
    
    func distanceColumns() -> [DistanceColumn] {
        return DistanceColumn.allColumns() as! [DistanceColumn]
    }
    
    func receipts() -> [WBReceipt] {
        let receipts = database.allReceipts(for: trip, ascending: true) as! [WBReceipt]
        return ReceiptIndexer.indexReceipts(receipts, filter: { WBReportUtils.filterOutReceipt($0) })
    }
    
    func distances() -> [Distance] {
        let distances = database.fetchedAdapterForDistances(in: trip, ascending: true)
        return distances?.allObjects() as! [Distance]
    }
    
    func receiptsByCategories() -> [String: [WBReceipt]] {
        var result = [String: [WBReceipt]]()
        for receipt in receipts() {
            if receipt.category == nil { continue }
            if result[receipt.category.name] == nil {
                result[receipt.category.name] = [WBReceipt]()
            }
            result[receipt.category.name]?.append(receipt)
        }
        
        if WBPreferences.printDailyDistanceValues() {
            let dReceipts = DistancesToReceiptsConverter.convertDistances(distances()) as! [WBReceipt]
            guard let firstReceipt = dReceipts.first else { return result }
            result[firstReceipt.category.name] = dReceipts
        }
        
        return result
    }
}

fileprivate func abstractMethodError() { fatalError("Abstract Method") }
