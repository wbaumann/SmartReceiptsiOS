//
//  ReceiptsPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import RxCocoa

class ReceiptsPresenter: Presenter {
    
    let receiptActionsSubject = PublishSubject<WBReceipt>()
    let generateReportSubject = PublishSubject<WBTrip>()
    let distancesSubject = PublishSubject<WBTrip>()
    let editReceiptSubject = PublishSubject<WBReceipt>()
    
    let disposeBag = DisposeBag()
    
    override func setupView(data: Any) {
        let trip = data as! WBTrip
        view.setup(trip: trip)
        router.moduleTrip = trip
        
        view.createReceiptButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.router.openCreateReceipt()
        }).disposed(by: disposeBag)
        
        view.createPhotoReceiptButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.router.openCreatePhotoReceipt()
        }).disposed(by: disposeBag)
        
        view.distancesButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.router.openDistances()
        }).disposed(by: disposeBag)
        
        view.generateReportButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.router.openGenerateReport()
        }).disposed(by: disposeBag)
        
        
        editReceiptSubject.subscribe(onNext: { [weak self] receipt in
            self?.router.openEdit(receipt: receipt)
        }).disposed(by: disposeBag)
        
        receiptActionsSubject.subscribe(onNext: { [weak self] receipt in
            self?.router.openActions(receipt: receipt)
        }).disposed(by: disposeBag)
    }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptsPresenter {
    var view: ReceiptsViewInterface {
        return _view as! ReceiptsViewInterface
    }
    var interactor: ReceiptsInteractor {
        return _interactor as! ReceiptsInteractor
    }
    var router: ReceiptsRouter {
        return _router as! ReceiptsRouter
    }
}
