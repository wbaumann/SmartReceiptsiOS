//
//  EditTripInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class EditTripInteractor: Interactor {
    
    private let disposeBag = DisposeBag()
    
    func configureSubscribers() {
        presenter.updateTripSubject.subscribe(onNext: { [weak self] trip in
            Logger.debug("Update Trip: \(trip.name)")
            Database.sharedInstance().update(trip) ? self?.presenter.close() : self?.presentError()
        }).disposed(by: disposeBag)
        
        presenter.addTripSubject.subscribe(onNext: { [weak self] trip in
            Logger.debug("Add Trip: \(trip.name)")
            Database.sharedInstance().save(trip) ? self?.presenter.close() : self?.presentError()
        }).disposed(by: disposeBag)
    }
    
    private func presentError() {
        presenter.presentAlert(title: nil, message: LocalizedString("edit.trip.generic.save.error.message"))
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditTripInteractor {
    var presenter: EditTripPresenter {
        return _presenter as! EditTripPresenter
    }
}
