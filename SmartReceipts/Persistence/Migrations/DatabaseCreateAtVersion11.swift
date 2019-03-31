//
//  DatabaseCreateAtVersion11.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 30/03/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation

class DatabaseCreateAtVersion11: DatabaseMigration {
    
    var version: Int {
        return 11
    }
    
    func migrate(_ database: Database) -> Bool {
        AnalyticsManager.sharedManager.record(event: Event.startDatabaseUpgrade(version))
        
        let result = setupAndroidMetadataTable(in: database.databaseQueue)
            && database.createTripsTable()
            && database.createReceiptsTable()
            && database.createCategoriesTable()
            && database.createCSVColumnsTable()
            && database.createPDFColumnsTable()
            && insertDefaultCategories(into: database)
            && insertDefaultReceiptColumns(into: database)
        
        AnalyticsManager.sharedManager.record(event: Event.finishDatabaseUpgrade(version, success: result))
        
        return result
    }
    
    func setupAndroidMetadataTable(in queue: FMDatabaseQueue) -> Bool {
        var result: Bool = false
        queue.inDatabase({ database in
            result = database.executeUpdate("CREATE TABLE android_metadata (locale TEXT)")
            if result {
                // Android need at least 1 locale to not crush, let it be en_US
                result = database.executeUpdate("INSERT INTO \"android_metadata\" VALUES('en_US')")
            }
        })
        return result
    }
    
    func insertDefaultCategories(into database: Database) -> Bool {
        Logger.debug("Insert default categories")
        
        // categories are localized because they are custom and red from db anyway
        let cats = [
            LocalizedString("category_null"),
            LocalizedString("category_null_code"),
            LocalizedString("category_airfare"),
            LocalizedString("category_airfare_code"),
            LocalizedString("category_breakfast"),
            LocalizedString("category_breakfast_code"),
            LocalizedString("category_dinner"),
            LocalizedString("category_dinner_code"),
            LocalizedString("category_entertainment"),
            LocalizedString("category_entertainment_code"),
            LocalizedString("category_gasoline"),
            LocalizedString("category_gasoline_code"),
            LocalizedString("category_gift"),
            LocalizedString("category_gift_code"),
            LocalizedString("category_hotel"),
            LocalizedString("category_hotel_code"),
            LocalizedString("category_laundry"),
            LocalizedString("category_laundry_code"),
            LocalizedString("category_lunch"),
            LocalizedString("category_lunch_code"),
            LocalizedString("category_other"),
            LocalizedString("category_other_code"),
            LocalizedString("category_parking_tolls"),
            LocalizedString("category_parking_tolls_code"),
            LocalizedString("category_postage_shipping"),
            LocalizedString("category_postage_shipping_code"),
            LocalizedString("category_car_rental"),
            LocalizedString("category_car_rental_code"),
            LocalizedString("category_taxi_bus"),
            LocalizedString("category_taxi_bus_code"),
            LocalizedString("category_telephone_fax"),
            LocalizedString("category_telephone_fax_code"),
            LocalizedString("category_tip"),
            LocalizedString("category_tip_code"),
            LocalizedString("category_train"),
            LocalizedString("category_train_code"),
            LocalizedString("category_books_periodicals"),
            LocalizedString("category_books_periodicals_code"),
            LocalizedString("category_cell_phone"),
            LocalizedString("category_cell_phone_code"),
            LocalizedString("category_dues_subscriptions"),
            LocalizedString("category_dues_subscriptions_code"),
            LocalizedString("category_meals_justified"),
            LocalizedString("category_meals_justified_code"),
            LocalizedString("category_stationery_stations"),
            LocalizedString("category_stationery_stations_code"),
            LocalizedString("category_training_fees"),
            LocalizedString("category_training_fees_code")
        ]
        
        var i = 0
        while i < cats.count - 1 {
            let name = cats[i]
            let code = cats[i + 1]
            let insert = "INSERT INTO \(CategoriesTable.Name) (\(CategoriesTable.Column.Name), \(CategoriesTable.Column.Code)) VALUES ('\(name)', '\(code)')"
            if !database.executeUpdate(insert) {
                return false
            }
            i += 2
        }
        return true
    }
    
    func insertDefaultReceiptColumns(into database: Database) -> Bool {
        let csvColumns: [Any] = [
            ReceiptColumn(name: LocalizedString("RECEIPTMENU_FIELD_DATE")),
            ReceiptColumn(name: LocalizedString("RECEIPTMENU_FIELD_NAME")),
            ReceiptColumn(name: LocalizedString("RECEIPTMENU_FIELD_PRICE")),
            ReceiptColumn(name: LocalizedString("RECEIPTMENU_FIELD_CURRENCY")),
            ReceiptColumn(name: LocalizedString("column_item_category_name")),
            ReceiptColumn(name: LocalizedString("column_item_category_code")),
            ReceiptColumn(name: LocalizedString("RECEIPTMENU_FIELD_COMMENT")),
            ReceiptColumn(name: LocalizedString("graphs_label_reimbursable"))
        ]
        
        
        if !database.replaceAllCSVColumns(with: csvColumns) {
            Logger.warning("Error while inserting CSV columns")
            return false
        }
        
        let pdfColumns: [Any] = [
            ReceiptColumn(name: LocalizedString("RECEIPTMENU_FIELD_DATE")),
            ReceiptColumn(name: LocalizedString("RECEIPTMENU_FIELD_NAME")),
            ReceiptColumn(name: LocalizedString("RECEIPTMENU_FIELD_PRICE")),
            ReceiptColumn(name: LocalizedString("RECEIPTMENU_FIELD_CURRENCY")),
            ReceiptColumn(name: LocalizedString("column_item_category_name")),
            ReceiptColumn(name: LocalizedString("graphs_label_reimbursable"))
        ]
        
        return database.replaceAllPDFColumns(with: pdfColumns)
    }
}
