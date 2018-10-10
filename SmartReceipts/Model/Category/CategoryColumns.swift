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
            CategoryColumn(index: 0, name: LocalizedString("filter_name_receipt_category")),
            CategoryCodeCloumn(index: 0, name: LocalizedString("column_item_category_code")),
            CategoryCurrencyColumn(index: 0, name: LocalizedString("RECEIPTMENU_FIELD_CURRENCY")),
            CategoryPriceColumn(index: 0, name: LocalizedString("RECEIPTMENU_FIELD_PRICE")),
            CategoryTaxColumn(index: 0, name: LocalizedString("RECEIPTMENU_FIELD_TAX")),
        ]
    }
    
    override func value(fromRow row: Any!, forCSV: Bool) -> String! {
        return valueFrom(receipts: row as! [WBReceipt])
    }
    
    func valueFrom(receipts: [WBReceipt]) -> String {
        guard let firstReceipt = receipts.first else { return "" }
        return "\(firstReceipt.category?.name ?? "") [\(receipts.count)]"
    }
}

//MARK: Categories

class CategoryCodeCloumn: CategoryColumn {
    override func valueFrom(receipts: [WBReceipt]) -> String {
        guard let firstReceipt = receipts.first else { return "" }
        return firstReceipt.category?.code ?? ""
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
        let total = PricesCollection()
        for rec in receipts {
            total.addPrice(rec.price())
        }
        return total.amountAsString()
    }
}

class CategoryTaxColumn: CategoryColumn {
    override func valueFrom(receipts: [WBReceipt]) -> String {
        let total = PricesCollection()
        for rec in receipts {
            total.addPrice(rec.tax())
        }
        return total.amountAsString()
    }
}


