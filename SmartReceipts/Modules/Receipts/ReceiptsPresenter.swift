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
    let editReceiptSubject = PublishSubject<WBReceipt>()
    let receiptDeleteSubject = PublishSubject<WBReceipt>()
    let createReceiptTextSubject = PublishSubject<Void>()
    let createReceiptCameraSubject = PublishSubject<Void>()
    let importReceiptFileSubject = PublishSubject<Void>()
    let contentChanged = PublishSubject<Void>()
    
    let bag = DisposeBag()
    
    var scanService: ScanService { return interactor.scanService }
    
    override func viewHasLoaded() {
        interactor.configureSubscribers()
        
        editReceiptSubject.subscribe(onNext: { [unowned self] receipt in
            self.router.openEdit(receipt: receipt)
        }).disposed(by: bag)
        
        receiptActionsSubject.subscribe(onNext: { [unowned self] receipt in
            let actionsPresenter = self.router.openActions(receipt: receipt)
            
            actionsPresenter.swapUpTap.subscribe(onNext: {
                self.interactor.swapUpReceipt(receipt)
            }).disposed(by: self.bag)
            
            actionsPresenter.swapDownTap.subscribe(onNext: {
                self.interactor.swapDownReceipt(receipt)
            }).disposed(by: self.bag)
            
            actionsPresenter.viewImageTap
                .subscribe(onNext:{
                    receipt.attachemntType == .image ?
                        self.router.openImageViewer(for: receipt) :
                        self.router.openPDFViewer(for: receipt)
                }).disposed(by: self.bag)
            
        }).disposed(by: bag)
    }
    
    override func setupView(data: Any) {
        let trip = data as! WBTrip
        view.setup(trip: trip)
        view.setup(fetchedModelAdapter: interactor.fetchedAdapter(for: trip))
        interactor.trip = trip
        router.moduleTrip = trip
        
        createReceiptTextSubject.subscribe(onNext: { [unowned self] in
            self.router.openCreateReceipt()
        }).disposed(by: bag)
        
        createReceiptCameraSubject.subscribe(onNext: { [unowned self] in
            self.router.openCreatePhotoReceipt()
        }).disposed(by: bag)
        
        importReceiptFileSubject.subscribe(onNext: { [unowned self] in
            self.router.openImportReceiptFile()
        }).disposed(by: bag)
    }
}

extension ReceiptsPresenter: TitleSubtitleProtocol {
    var titleSubtitle: TitleSubtitle {
        return interactor.titleSubtitle()
    }
    
    var contentChangedSubject: PublishSubject<Void>? {
        return contentChanged
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
