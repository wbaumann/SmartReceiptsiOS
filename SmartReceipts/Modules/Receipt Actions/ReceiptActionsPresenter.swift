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
    
    let handleAttachTap = PublishSubject<Void>()
    let takeImageTap = PublishSubject<Void>()
    let retakeImageTap = PublishSubject<Void>()
    let viewImageTap = PublishSubject<Void>()
    let moveTap = PublishSubject<Void>()
    let copyTap = PublishSubject<Void>()
    let swapUpTap = PublishSubject<Void>()
    let swapDownTap = PublishSubject<Void>()
    
    let disposeBag = DisposeBag()
    
    override func viewHasLoaded() {
        super.viewHasLoaded()
        
        view.doneButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.router.close()
        }).disposed(by: disposeBag)
        
        handleAttachTap.subscribe(onNext: {
            NSLog("handleAttachTap")
        }).disposed(by: disposeBag)
        
        takeImageTap.subscribe(onNext: {
            NSLog("takeImageTap")
        }).disposed(by: disposeBag)
        
        retakeImageTap.subscribe(onNext: {
            NSLog("retakeImageTap")
        }).disposed(by: disposeBag)
        
        viewImageTap.subscribe(onNext: {
            NSLog("viewImageTap")
        }).disposed(by: disposeBag)
        
        moveTap.subscribe(onNext: {
            NSLog("moveTap")
        }).disposed(by: disposeBag)
        
        copyTap.subscribe(onNext: {
            NSLog("copyTap")
        }).disposed(by: disposeBag)
        
        swapUpTap.subscribe(onNext: {
            NSLog("swapUpTap")
        }).disposed(by: disposeBag)
        
        swapDownTap.subscribe(onNext: {
            NSLog("swapDownTap")
        }).disposed(by: disposeBag)
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
