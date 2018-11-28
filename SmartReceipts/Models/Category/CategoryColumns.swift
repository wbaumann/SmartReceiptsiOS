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
            CategoryNameColumn(type: 0, name: LocalizedString("category_name_field")),
            CategoryCodeColumn(type: 1, name: LocalizedString("category_code_field")),
            CategoryCurrencyColumn(type: 2, name: LocalizedString("RECEIPTMENU_FIELD_CURRENCY")),
            CategoryPriceColumn(type: 3, name: LocalizedString("category_price_field")),
            CategoryTaxColumn(type: 4, name: LocalizedString("category_tax_field")),
            CategoryPriceExchnagedColumn(type: 5, name: LocalizedString("category_price_exchanged_field"))
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

class CategoryNameColumn: CategoryColumn {
    override func valueFrom(receipts: [WBReceipt]) -> String {
        guard let firstReceipt = receipts.first else { return "" }
        return firstReceipt.category?.name ?? ""
    }
}

class CategoryCodeColumn: CategoryColumn {
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
        
        if otherCollection.hasValue() {
            let totalPrice = Price(amount: total, currency: receipts.first!.trip.defaultCurrency)
            return "\(totalPrice.currencyFormattedPrice()); \(otherCollection.currencyFormattedPrice())"
        } else {
            return Price.stringFrom(amount: total)
        }
    }
}


