//
//  TripDistancesPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class TripDistancesPresenter: Presenter {
    
    let contentChanged = PublishSubject<Void>()
    
    func fetchedModelAdapter(for trip: WBTrip) -> FetchedModelAdapter {
        return interactor.fetchedModelAdapter(for: trip)
    }
    
    func delete(distance: Distance) {
        interactor.delete(distance: distance)
    }
    
    func presentEditDistance(with data: Any?) {
        router.showEditDistance(with: data)
    }
    
    func totalDistancePrice() -> String {
        return interactor.totalDistancePrice()
    }
    
    override func setupView(data: Any) {
        if let trip = data as? WBTrip {
            view.setup(trip: trip)
            interactor.trip = trip
        }
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension TripDistancesPresenter {
    var view: TripDistancesViewInterface {
        return _view as! TripDistancesViewInterface
    }
    var interactor: TripDistancesInteractor {
        return _interactor as! TripDistancesInteractor
    }
    var router: TripDistancesRouter {
        return _router as! TripDistancesRouter
    }
}
