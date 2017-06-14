//
//  TripsRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

class TripsRouter: Router {
    
    func openSettings() {
        let settingsVC = MainStoryboard().instantiateViewController(withIdentifier: "SettingsOverflow")
        settingsVC.modalTransitionStyle = .coverVertical
        settingsVC.modalPresentationStyle = .formSheet
        _view.present(settingsVC, animated: true, completion: nil)
    }
    
    func openEdit(trip: WBTrip) {
        Module.build(AppModules.editTrip).router.show(from: _view, embedInNavController: true, setupData: trip)
    }
    
    func openAddTrip() {
        Module.build(AppModules.editTrip).router.show(from: _view, embedInNavController: true)
    }
    
    func openDetails(trip: WBTrip) {
        let vc = MainStoryboard().instantiateViewController(withIdentifier: "Receipts")
        let receiptsVC = vc as! WBReceiptsViewController
        receiptsVC.trip = trip
        _view.navigationController?.pushViewController(receiptsVC, animated: true)
    }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension TripsRouter {
    var presenter: TripsPresenter {
        return _presenter as! TripsPresenter
    }
}
