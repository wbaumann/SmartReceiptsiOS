//
//  TripsPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import UserNotifications

protocol TripsModuleInterface {
    var tripSelected: Observable<WBTrip> { get }
}

class TripsPresenter: Presenter {
    let tripSelectedSubject = PublishSubject<WBTrip>()
    let tripEditSubject = PublishSubject<WBTrip>()
    let tripDeleteSubject = PublishSubject<WBTrip>()
    
    private(set) var lastOpenedTrip: WBTrip?
    
    private let bag = DisposeBag()
    
    override func viewHasLoaded() {
        interactor.configureSubscribers()
        
        tripSelectedSubject
            .do(onNext: { WBPreferences.markLastOpened(trip: $0) })
            .subscribe(onNext: { _ in
                self.router.dismiss()
            }).disposed(by: bag)
        
        view.addButtonTap
            .subscribe(onNext: {
                self.router.openAddTrip()
            }).disposed(by: bag)
        
        view.privacyTap
            .subscribe(onNext: {
                self.router.openPrivacySettings()
            }).disposed(by: bag)
        
        tripEditSubject
            .subscribe(onNext: { trip in
                self.router.openEdit(trip: trip)
            }).disposed(by: bag)
    }
    
    func presentAddTrip() {
        router.openAddTrip()
    }
    
    func fetchedModelAdapter() -> FetchedModelAdapter? {
        return interactor.fetchedModelAdapter()
    }
}

extension TripsPresenter: TripsModuleInterface {
    var tripSelected: Observable<WBTrip> {
        return tripSelectedSubject
    }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension TripsPresenter {
    var view: TripsViewInterface {
        return _view as! TripsViewInterface
    }
    var interactor: TripsInteractor {
        return _interactor as! TripsInteractor
    }
    var router: TripsRouter {
        return _router as! TripsRouter
    }
}
