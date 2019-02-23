//
//  ColumnsPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class ColumnsPresenter: Presenter {
    private let bag = DisposeBag()
    private var isCSV: Bool = false
    let reorderSubject = PublishSubject<(Column,Column)>()
    let addSubject = PublishSubject<(Column)>()
    let removeSubject = PublishSubject<(Column)>()
    
    override func setupView(data: Any) {
        isCSV = data as! Bool
        updateData()
        
        view.setNavTitle(isCSV ? LocalizedString("pref_output_custom_csv_title") : LocalizedString("pref_output_custom_pdf_title"))
    }
    
    override func viewHasLoaded() {
        reorderSubject
            .subscribe(onNext: { [unowned self] left, right in
                self.interactor.reorder(columnLeft: left, columnRight: right, isCSV: self.isCSV)
                self.updateData()
            }).disposed(by: bag)
        
        addSubject
            .subscribe(onNext: { [unowned self] column in
                self.interactor.addColumn(column ,isCSV: self.isCSV)
            }).disposed(by: bag)
        
        removeSubject
            .subscribe(onNext: { [unowned self] column in
                self.interactor.removeColumn(column ,isCSV: self.isCSV)
            }).disposed(by: bag)
    }
    
    func nextObjectID() -> Int {
        let db = Database.sharedInstance()!
        return isCSV ? db.nextCSVColumnObjectID() : db.nextPDFColumnObjectID()
    }
    
    func updateData() {
        interactor
            .columns(forCSV: isCSV)
            .bind(to: view.columnsVar)
            .dispose()
    }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ColumnsPresenter {
    var view: ColumnsViewInterface {
        return _view as! ColumnsViewInterface
    }
    var interactor: ColumnsInteractor {
        return _interactor as! ColumnsInteractor
    }
    var router: ColumnsRouter {
        return _router as! ColumnsRouter
    }
}
