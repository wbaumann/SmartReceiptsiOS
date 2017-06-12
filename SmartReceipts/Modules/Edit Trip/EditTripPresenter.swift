//
//  EditTripPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class EditTripPresenter: Presenter {
    let updateTripSubject = PublishSubject<WBTrip>()
    let addTripSubject = PublishSubject<WBTrip>()
    
    override func viewHasLoaded() {
        interactor.configureSubscribers()
    }
    
    override func setupView(data: Any) {
        view.setup(trip: data as! WBTrip)
    }
    
    func close() {
        router.close()
    }
    
    func presentAlert(title: String?, message: String) {
        router.openAlert(title: title, message: message)
    }
    
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditTripPresenter {
    var view: EditTripViewInterface {
        return _view as! EditTripViewInterface
    }
    var interactor: EditTripInteractor {
        return _interactor as! EditTripInteractor
    }
    var router: EditTripRouter {
        return _router as! EditTripRouter
    }
}
