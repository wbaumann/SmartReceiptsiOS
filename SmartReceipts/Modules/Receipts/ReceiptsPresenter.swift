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
    let viewReceiptAttachmentTap = PublishSubject<Void>()
    
    let bag = DisposeBag()
    
    var scanService: ScanService { return interactor.scanService }
    
    override func viewHasLoaded() {
        interactor.configureSubscribers()
        
        editReceiptSubject.subscribe(onNext: { [unowned self] receipt in
            self.router.openEdit(receipt: receipt)
        }).disposed(by: bag)
        
        receiptActionsSubject.subscribe(onNext: { [unowned self] receipt in
            let actionsPresenter = self.router.openActions(receipt: receipt)
            
            actionsPresenter.actionTap
                .filterCases(cases: .edit)
                .delay(VIEW_CONTROLLER_TRANSITION_DELAY, scheduler: MainScheduler.instance)
                .subscribe(onNext: { _ in
                    self.router.openEdit(receipt: receipt)
                }).disposed(by: self.bag)
            
            actionsPresenter.actionTap
                .filterCases(cases: .swapUp)
                .subscribe(onNext: { _ in
                    self.interactor.swapUpReceipt(receipt)
                }).disposed(by: self.bag)
            
            actionsPresenter.actionTap
                .filterCases(cases: .swapDown)
                .subscribe(onNext: { _ in
                    self.interactor.swapDownReceipt(receipt)
                }).disposed(by: self.bag)
            
            actionsPresenter.actionTap
                .filterCases(cases: .viewImage)
                .subscribe(onNext: { _ in
                    self.presentAttachment(for: receipt)
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
    
    func presentAttachment(for receipt: WBReceipt) {
        receipt.attachemntType == .image ? router.openImageViewer(for: receipt) : router.openPDFViewer(for: receipt)
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
