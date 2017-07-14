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
    
    func update(columns: [Column], forCSV: Bool) {
        let db = Database.sharedInstance()!
        let result = forCSV ? db.replaceAllCSVColumns(with: columns) : db.replaceAllPDFColumns(with: columns)
        Logger.info("Saving columns. Result: \(result)")
    }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ColumnsInteractor {
    var presenter: ColumnsPresenter {
        return _presenter as! ColumnsPresenter
    }
}
