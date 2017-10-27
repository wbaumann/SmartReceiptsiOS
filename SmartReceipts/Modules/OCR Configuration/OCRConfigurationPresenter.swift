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
                let bag = sSelf.bag
                let price = Observable<String>.just(product.localizedPrice)
                product.productIdentifier == PRODUCT_OCR_10 ?
                    price.bind(to: sSelf.view.OCR10Price).disposed(by: bag) : ()
                
                product.productIdentifier == PRODUCT_OCR_50 ?
                    price.bind(to: sSelf.view.OCR50Price).disposed(by: bag) : ()
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
