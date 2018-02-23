//
//  OCRConfigurationPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/10/2017.
//Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import StoreKit

class OCRConfigurationPresenter: Presenter {
    private let bag = DisposeBag()
    
    override func viewHasLoaded() {
        interactor.requestProducts()
            .subscribe(onNext: { [weak self] product in
                guard let sSelf = self else { return }
                let price = Observable<String>.just(product.localizedPrice)
                if product.productIdentifier == PRODUCT_OCR_10 {
                    _ = price.bind(to: sSelf.view.OCR10Price)
                } else if product.productIdentifier == PRODUCT_OCR_50 {
                    _ = price.bind(to: sSelf.view.OCR50Price)
                }
            }).disposed(by: bag)
        
        view.buy10ocr
            .do(onNext: { Logger.debug("But 10 OCR Tap") })
            .subscribe(onNext: { [unowned self] in
                self.interactor.purchase(product: PRODUCT_OCR_10)
            }).disposed(by: bag)
        
        view.buy50ocr
            .do(onNext: { Logger.debug("But 50 OCR Tap") })
            .subscribe(onNext: { [unowned self] in
                self.interactor.purchase(product: PRODUCT_OCR_50)
            }).disposed(by: bag)
    }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension OCRConfigurationPresenter {
    var view: OCRConfigurationViewInterface {
        return _view as! OCRConfigurationViewInterface
    }
    var interactor: OCRConfigurationInteractor {
        return _interactor as! OCRConfigurationInteractor
    }
    var router: OCRConfigurationRouter {
        return _router as! OCRConfigurationRouter
    }
}
