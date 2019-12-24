//
//  TripsRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import SafariServices

class TripsRouter: Router {
    
    private let moduleStoryboard = UIStoryboard(name: "Trips", bundle: nil)
    
    func openPrivacySettings() {
        let module = AppModules.settings.build()
        module.presenter.setupView(data: ShowSettingsOption.privacySection)
        openModal(module: module)
    }
    
    func openDebug() {
        let module = AppModules.debug.build()
        openModal(module: module)
    }
    
    func openEdit(trip: WBTrip) {
        openEditTrip(trip)
    }
    
    func openAddTrip() {
        openEditTrip(nil)
    }
    
    func openNoTrips() {
        let vc = moduleStoryboard.instantiateViewController(withIdentifier: "NoTrips")
        _view.viewController.splitViewController?.show(vc, sender: nil)
    }
    
    private func openEditTrip(_ trip: WBTrip?) {
        AppModules.editTrip.build().router.show(from: _view.viewController, embedInNavController: true, setupData: trip)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension TripsRouter {
    var presenter: TripsPresenter {
        return _presenter as! TripsPresenter
    }
}
