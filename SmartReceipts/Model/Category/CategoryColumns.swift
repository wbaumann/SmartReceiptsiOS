//
//  CategoryColumns.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 13/01/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

class CategoryColumn: Column {
    class func allColumns() -> [CategoryColumn] {
        return [
            CategoryColumn(index: 0, name: LocalizedString("category.column.category")),
            CategoryCodeCloumn(index: 0, name: LocalizedString("category.column.category.code")),
            CategoryCurrencyColumn(index: 0, name: LocalizedString("category.column.currency")),
            CategoryPriceColumn(index: 0, name: LocalizedString("category.column.price")),
            CategoryTaxColumn(index: 0, name: LocalizedString("category.column.tax")),
        ]
    }
    
    override func value(fromRow row: Any!, forCSV: Bool) -> String! {
        return valueFrom(receipts: row as! [WBReceipt])
    }
    
    func valueFrom(receipts: [WBReceipt]) -> String {
        guard let firstReceipt = receipts.first else { return "" }
        return "\(firstReceipt.category.name ?? "") [\(receipts.count)]"
    }
}

//MARK: Categories

class CategoryCodeCloumn: CategoryColumn {
    override func valueFrom(receipts: [WBReceipt]) -> String {
        guard let firstReceipt = receipts.first else { return "" }
        for category in Database.sharedInstance().listAllCategories() {
            if category.name == firstReceipt.category.name { return category.code }
        }
        return ""
    }
}

class CategoryCurrencyColumn: CategoryColumn {
    override func valueFrom(receipts: [WBReceipt]) -> String {
        guard let firstReceipt = receipts.first else { return "" }
        return firstReceipt.currency.code
    }
}

class CategoryPriceColumn: CategoryColumn {
    override func valueFrom(receipts: [WBReceipt]) -> String {
        var total = NSDecimalNumber.zero
        for receipt in receipts {
            total = total.adding(receipt.price().amount)
        }
        return Price.stringFrom(amount: total)
    }
}

class CategoryTaxColumn: CategoryColumn {
    override func valueFrom(receipts: [WBReceipt]) -> String {
        var total = NSDecimalNumber.zero
        for receipt in receipts {
            total = total.adding(receipt.tax()!.amount)
        }
        return Price.stringFrom(amount: total)
    }
}


