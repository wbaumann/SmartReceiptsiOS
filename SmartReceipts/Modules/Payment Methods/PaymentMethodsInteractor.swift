//
//  PaymentMethodsInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift


class PaymentMethodsInteractor: Interactor {
    
    let bag = DisposeBag()
    
    func configureSubscribers() {
        presenter.paymentMethodAction.subscribe(onNext: { [unowned self] (pm: PaymentMethod, update: Bool) in
            self.save(paymentMethod: pm, update: update)
        }).disposed(by: bag)
        
        presenter.deleteSubject.subscribe(onNext: { method in
            Database.sharedInstance().delete(method)
        }).disposed(by: bag)
    }
    
    func fetchedModelAdapter() -> FetchedModelAdapter? {
        return Database.sharedInstance().fetchedAdapterForPaymentMethods()
    }
    
    private func save(paymentMethod: PaymentMethod, update: Bool) {
        if paymentMethod.method == nil || paymentMethod.method.isEmpty {
            presenter.presentAlert(title: LocalizedString("edit.payment.method.controller.save.error.title"),
                                 message: LocalizedString("edit.payment.method.controller.save.error.message"))
            return
        }
        
        if Database.sharedInstance().hasPaymentMethod(withName: paymentMethod.method) {
            presenter.presentAlert(title: LocalizedString("edit.payment.method.controller.save.error.title"),
                                 message: LocalizedString("edit.payment.method.controller.save.error.exists.message"))
            return
        }
        
        let db = Database.sharedInstance()!
        let success = update ? db.update(paymentMethod) : db.save(paymentMethod)
        
        if !success {
            presenter.presentAlert(title: LocalizedString("edit.payment.method.controller.save.error.title"),
                                 message: LocalizedString("edit.payment.method.controller.save.error.generic.message"))
        }
    }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension PaymentMethodsInteractor {
    var presenter: PaymentMethodsPresenter {
        return _presenter as! PaymentMethodsPresenter
    }
}
