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
            CategoryNameColumn(type: 0, name: WBPreferences.localized(key: "category_name_field")),
            CategoryCodeColumn(type: 1, name: WBPreferences.localized(key: "category_code_field")),
            CategoryPriceColumn(type: 2, name: WBPreferences.localized(key: "category_price_field")),
            CategoryTaxColumn(type: 3, name: WBPreferences.localized(key: "category_tax_field")),
            CategoryPriceExchnagedColumn(type: 4, name: WBPreferences.localized(key: "category_price_exchanged_field"))
        ]
    }
    
    override func value(fromRow row: Any!, forCSV: Bool) -> String! {
        guard let categorizedReceipts = row as? (_: WBCategory, receipts: [WBReceipt]) else { return "" }
        return valueFrom(receipts: categorizedReceipts.receipts)
    }
    
    func valueFrom(receipts: [WBReceipt]) -> String {
        ABSTRACT_METHOD()
        return ""
    }
}

//MARK: Categories

class CategoryNameColumn: CategoryColumn {
    override func valueFrom(receipts: [WBReceipt]) -> String {
        guard let firstReceipt = receipts.first else { return "" }
        return "\(firstReceipt.category?.name ?? "") [\(receipts.count)]"
    }
}

class CategoryCodeColumn: CategoryColumn {
    override func valueFrom(receipts: [WBReceipt]) -> String {
        guard let firstReceipt = receipts.first else { return "" }
        return firstReceipt.category?.code ?? ""
    }
}

class CategoryPriceColumn: CategoryColumn {
    override func valueFrom(receipts: [WBReceipt]) -> String {
        let total = PricesCollection()
        for rec in receipts {
            total.addPrice(rec.price())
        }
        return total.currencyFormattedTotalPrice()
    }
}

class CategoryTaxColumn: CategoryColumn {
    override func valueFrom(receipts: [WBReceipt]) -> String {
        let total = PricesCollection()
        for rec in receipts {
            total.addPrice(rec.tax())
        }
        
        var result = total.currencyFormattedTotalPrice()
        if result.isEmpty { result = Price(amount: 0, currency: receipts.first!.trip.defaultCurrency).currencyFormattedPrice() }
        return result
    }
}

class CategoryPriceExchnagedColumn: CategoryColumn {
    override func valueFrom(receipts: [WBReceipt]) -> String {
        let otherCollection = PricesCollection()
        var total = NSDecimalNumber.zero
        
        for rec in receipts {
            if let exchangedPrice = rec.exchangedPrice() {
                total = total.adding(exchangedPrice.amount)
            } else {
                otherCollection.addPrice(rec.price())
            }
        }
        
        let totalPrice = Price(amount: total, currency: receipts.first!.trip.defaultCurrency)
        return "\(totalPrice.currencyFormattedPrice()); \(otherCollection.currencyFormattedTotalPrice())"
    }
}


