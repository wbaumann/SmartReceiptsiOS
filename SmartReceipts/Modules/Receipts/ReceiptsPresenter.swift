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
    let viewReceiptAttachmentTap = PublishSubject<Void>()
    let receiptActionRelay = PublishRelay<(WBReceipt, ReceiptAction)>()
    
    let bag = DisposeBag()
    
    private (set) var tooltipPresenter: TooltipPresenter!
    var scanService: ScanService { return interactor.scanService }
    
    override func viewHasLoaded() {
        interactor.configureSubscribers()
        
        tooltipPresenter = TooltipPresenter(view: view.viewForTooltip, trip: interactor.trip)
        
        editReceiptSubject
            .subscribe(onNext: { [unowned self] receipt in
                self.router.openEdit(receipt: receipt)
            }).disposed(by: bag)
        
        receiptActionsSubject
            .flatMap { receipt in ReceiptActionSheet(receipt: receipt).show().map { (receipt, $0) } }
            .bind(to: receiptActionRelay)
            .disposed(by: bag)
            
        receiptActionRelay
            .subscribe(onNext: { [weak self] receipt, action in
                switch action {
                case .edit: self?.router.openEdit(receipt: receipt)
                case .swapUp: self?.interactor.swapUpReceipt(receipt)
                case .swapDown: self?.interactor.swapDownReceipt(receipt)
                case .move: self?.router.openMove(receipt: receipt)
                case .copy: self?.router.openCopy(receipt: receipt)
                case .delete: self?.receiptDeleteSubject.onNext(receipt)
                case .attachImage: _ = self?.interactor.attachAppInputFile(to: receipt)
                }
            }).disposed(by: bag)
    }
    
    func onReceiptImageTap(receipt: WBReceipt) {
        receipt.attachemntType == .none ? takeImage(for: receipt) : presentAttachment(for: receipt)
    }
    
    private func takeImage(for receipt: WBReceipt) {
        ImagePicker.shared.presentPicker(on: _view.viewController)
            .subscribe(onSuccess: { [weak self] image in
                _ = self?.interactor.attachImage(image, to: receipt)
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
    
    func presentBackups() {
        router.openBackups()
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
