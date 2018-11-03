//
//  ColumnsInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class ColumnsInteractor: Interactor {
    
    
    func columns(forCSV: Bool) -> Observable<[Column]> {
        let columns = forCSV ? Database.sharedInstance().allCSVColumns() : Database.sharedInstance().allPDFColumns()
        for (idx, column) in columns!.enumerated() {
            let col = column as! Column
            col.uniqueIdentity = "\(idx)"
        }
        return Observable<[Column]>.just(columns as! [Column])
    }
    
    func addColumn(_ column: Column, isCSV: Bool) {
        let db = Database.sharedInstance()!
        let orderId = isCSV ? db.nextCustomOrderIdForCSVColumn() : db.nextCustomOrderIdForPDFColumn()
        column.customOrderId = orderId
        let result = isCSV ? db.addCSVColumn(column) : db.addPDFColumn(column)
        Logger.info("Add Column '\(column.name!)'. Result: \(result)")
    }
    
    func removeColumn(_ column: Column, isCSV: Bool) {
        let db = Database.sharedInstance()!
        let result = isCSV ? db.removeCSVColumn(column) : db.removePDFColumn(column)
        Logger.info("Remove Column '\(column.name!)'. Result: \(result)")
    }
    
    func reorder(columnLeft: Column, columnRight: Column, isCSV: Bool) {
        let db = Database.sharedInstance()!
        let result = isCSV ? db.reorderCSVColumn(columnLeft, withCSVColumn: columnRight) :
                             db.reorderPDFColumn(columnLeft, withPDFColumn: columnRight)
        Logger.info("Reorder columns. Result: \(result)")
    }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ColumnsInteractor {
    var presenter: ColumnsPresenter {
        return _presenter as! ColumnsPresenter
    }
}
