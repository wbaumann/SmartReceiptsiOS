//
//  PaymentMethodsPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

typealias PaymentMethodAction = (pm: PaymentMethod, update: Bool)

class PaymentMethodsPresenter: Presenter {
    
    let paymentMethodAction = PublishSubject<PaymentMethodAction>()
    let deleteSubject = PublishSubject<PaymentMethod>()
    
    override func viewHasLoaded() {
        interactor.configureSubscribers()
    }
 
    func presentAlert(title: String?, message: String) {
        router.openAlert(title: title, message: message)
    }
    
    func fetchedModelAdapter() -> FetchedModelAdapter? {
        return interactor.fetchedModelAdapter()
    }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension PaymentMethodsPresenter {
    var view: PaymentMethodsViewInterface {
        return _view as! PaymentMethodsViewInterface
    }
    var interactor: PaymentMethodsInteractor {
        return _interactor as! PaymentMethodsInteractor
    }
    var router: PaymentMethodsRouter {
        return _router as! PaymentMethodsRouter
    }
}
