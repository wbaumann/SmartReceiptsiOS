//
//  ReceiptActionsPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class ReceiptActionsPresenter: Presenter {
    
    private var receipt: WBReceipt!
    
    let editReceiptTap = PublishSubject<Void>()
    let handleAttachTap = PublishSubject<Void>()
    let takeImageTap = PublishSubject<Void>()
    let viewImageTap = PublishSubject<Void>()
    let moveTap = PublishSubject<Void>()
    let copyTap = PublishSubject<Void>()
    let swapUpTap = PublishSubject<Void>()
    let swapDownTap = PublishSubject<Void>()
    
    let bag = DisposeBag()
    
    required init(receipt: WBReceipt? = nil) {
        self.receipt = receipt
    }
    
    required init() {
        super.init()
    }
    
    override func setupView(data: Any) {
        receipt = data as! WBReceipt
        view.setup(receipt: receipt)
    }
    
    override func viewHasLoaded() {
        super.viewHasLoaded()
        view.doneButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.router.close()
        }).disposed(by: bag)
        
        configureSubscribers()
    }
    
    func configureSubscribers() {
        
        editReceiptTap.subscribe(onNext: { [unowned self] in
            Logger.info("Edit Receipt Tap")
            AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuEdit())
            self.router.close()
        }).disposed(by: bag)
        
        handleAttachTap.subscribe(onNext: { [unowned self] in
            Logger.info("Attach File Tap")
            AnalyticsManager.sharedManager.record(event: Event.receiptsImportPictureReceipt())
            _ = self.interactor.attachAppInputFile(to: self.receipt)
            self.router.close()
        }).disposed(by: bag)
        
        takeImageTap.subscribe(onNext: {
            Logger.info("Take Image Tap")
            self.takeImage()
            AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuRetakePhoto())
        }).disposed(by: bag)
        
        viewImageTap.subscribe(onNext: { [unowned self] in
            Logger.info("View Image Tap")
            if self.receipt.attachemntType == .image {
                AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuViewImage())
            } else if self.receipt.attachemntType == .pdf {
                AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuViewPdf())
            }
            self.router.close()
        }).disposed(by: bag)
        
        moveTap.subscribe(onNext: { [unowned self] in
            Logger.info("Move Receipt Tap")
            AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuMoveCopy())
            self.router.openMove(receipt: self.receipt)
        }).disposed(by: bag)
        
        copyTap.subscribe(onNext: { [unowned self] in
            Logger.info("Copy Receipt Tap")
            AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuMoveCopy())
            self.router.openCopy(receipt: self.receipt)
        }).disposed(by: bag)
        
        swapUpTap.subscribe(onNext: { [unowned self] in
            Logger.info("SwapUp Receipt Tap")
            AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuSwapUp())
            self.router.close()
        }).disposed(by: bag)
        
        swapDownTap.subscribe(onNext: { [unowned self] in
            Logger.info("SwapDown Receipt Tap")
            AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuSwapDown())
            self.router.close()
        }).disposed(by: bag)
    }
    
    private func takeImage() {
        ImagePicker.sharedInstance().rx_openOn(self.view as! UIViewController)
            .filter({ $0 != nil})
            .subscribe(onNext: { [unowned self] image in
                if self.interactor.attachImage(image!, to: self.receipt) {
                    self.view.updateForm()
                }
        }).disposed(by: bag)
    }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptActionsPresenter {
    var view: ReceiptActionsViewInterface {
        return _view as! ReceiptActionsViewInterface
    }
    var interactor: ReceiptActionsInteractor {
        return _interactor as! ReceiptActionsInteractor
    }
    var router: ReceiptActionsRouter {
        return _router as! ReceiptActionsRouter
    }
}
