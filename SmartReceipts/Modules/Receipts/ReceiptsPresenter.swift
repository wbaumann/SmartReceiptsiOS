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
        view.setup(fetchedModelAdapter: interactor.fetchedAdapter(for: trip))
        router.moduleTrip = trip
        
        view.createReceiptButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.router.openCreateReceipt()
        }).disposed(by: disposeBag)
        
        view.createPhotoReceiptButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.router.openCreatePhotoReceipt()
        }).disposed(by: disposeBag)
        
        view.distancesButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.router.openDistances()
        }).disposed(by: disposeBag)
        
        view.generateReportButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.router.openGenerateReport()
        }).disposed(by: disposeBag)
        
        
        editReceiptSubject.subscribe(onNext: { [unowned self] receipt in
            self.router.openEdit(receipt: receipt)
        }).disposed(by: disposeBag)
        
        receiptActionsSubject.subscribe(onNext: { [unowned self] receipt in
            let actionsPresenter = self.router.openActions(receipt: receipt)
            
            actionsPresenter.swapUpTap.subscribe(onNext: {
                Logger.debug("swapUpTap")
                self.interactor.swapUpReceipt(receipt)
            }).disposed(by: self.disposeBag)
            
            actionsPresenter.swapDownTap.subscribe(onNext: {
                Logger.debug("swapDownTap")
                self.interactor.swapDownReceipt(receipt)
            }).disposed(by: self.disposeBag)
            
            actionsPresenter.viewImageTap
             .delay(0, scheduler: MainScheduler.instance)
             .subscribe(onNext:{
                Logger.debug("viewImageTap")
                self.router.openImageViewer(for: receipt)
            }).disposed(by: self.disposeBag)
            
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
