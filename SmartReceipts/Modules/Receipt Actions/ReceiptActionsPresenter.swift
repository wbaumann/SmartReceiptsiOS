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

enum ReceiptAction {
    case edit, attachImage, importImage, viewImage, move, copy, swapUp, swapDown
}

class ReceiptActionsPresenter: Presenter {
    private var receipt: WBReceipt!
    
    let actionTap = PublishSubject<ReceiptAction>()
    
    let bag = DisposeBag()
    
    required init(receipt: WBReceipt? = nil) {
        self.receipt = receipt
    }
    
    required init() {
        super.init()
    }
    
    override func setupView(data: Any) {
        receipt = data as? WBReceipt
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
        
        actionTap.filterCases(cases: .move)
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuMoveCopy())
                Logger.info("Move Receipt Tap")
                self.router.openMove(receipt: self.receipt)
            }).disposed(by: bag)
        
        actionTap.filterCases(cases: .copy)
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuMoveCopy())
                Logger.info("Copy Receipt Tap")
                self.router.openCopy(receipt: self.receipt)
            }).disposed(by: bag)
        
        actionTap.filterCases(cases: .edit)
            .subscribe(onNext: { [weak self] _ in
                Logger.info("Edit Receipt Tap")
                AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuEdit())
                self?.router.close()
            }).disposed(by: bag)
        
        actionTap.filterCases(cases: .attachImage)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                Logger.info("Attach File Tap")
                AnalyticsManager.sharedManager.record(event: Event.receiptsImportPictureReceipt())
                _ = self.interactor.attachAppInputFile(to: self.receipt)
                self.router.close()
            }).disposed(by: bag)
        
        actionTap.filterCases(cases: .importImage)
            .subscribe(onNext: { [weak self] _ in
                Logger.info("Take Image Tap")
                self?.takeImage()
                AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuRetakePhoto())
            }).disposed(by: bag)
        
        actionTap.filterCases(cases: .viewImage)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                Logger.info("View Image Tap")
                switch self.receipt.attachemntType {
                case .image: AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuViewImage())
                case .pdf: AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuViewPdf())
                default: break
                }
                self.router.close()
            }).disposed(by: bag)
        
        actionTap.filterCases(cases: .swapUp)
            .subscribe(onNext: { [weak self] _ in
                Logger.info("SwapUp Receipt Tap")
                AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuSwapUp())
                self?.router.close()
            }).disposed(by: bag)
        
        actionTap.filterCases(cases: .swapDown)
            .subscribe(onNext: { [weak self] _ in
                Logger.info("SwapDown Receipt Tap")
                AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuSwapDown())
                self?.router.close()
            }).disposed(by: bag)
    }
    
    private func takeImage() {
        ImagePicker.shared.presentPicker(on: _view)
            .subscribe(onSuccess: { [unowned self] image in
                guard self.interactor.attachImage(image, to: self.receipt) else { return }
                self.view.updateForm()
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
