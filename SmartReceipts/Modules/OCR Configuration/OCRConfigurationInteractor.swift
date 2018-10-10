//
//  OCRConfigurationInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/10/2017.
//Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import StoreKit
import Toaster

class OCRConfigurationInteractor: Interactor {
    private let bag = DisposeBag()
    private var purchaseService: PurchaseService!
    
    required init() {
        purchaseService = PurchaseService()
    }
    
    init(purchaseService: PurchaseService) {
        super.init()
        self.purchaseService = purchaseService
    }
    
    func requestProducts() -> Observable<SKProduct> {
        return purchaseService.requestProducts()
    }
    
    func purchase(product: String) {
        let hud = PendingHUDView.show(on: presenter._view.view)
        purchaseService.purchase(prodcutID: product)
            .subscribe(onNext: { _ in
                hud.hide()
                let text = LocalizedString("purchase_succeeded")
                Toast.show(text)
            }, onError: { _ in
                hud.hide()
            }).disposed(by: bag)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension OCRConfigurationInteractor {
    var presenter: OCRConfigurationPresenter {
        return _presenter as! OCRConfigurationPresenter
    }
}
