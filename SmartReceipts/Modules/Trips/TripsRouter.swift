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
    
    private let moduleStoryboard = UIStoryboard(name: "Trips", bundle: nil)
    
    func openSettings() {
        let module = AppModules.settings.build()
        executeFor(iPhone: {
            module.router.show(from: _view, embedInNavController: true)
        }, iPad: {
            module.router.showIPadForm(from: _view, needNavigationController: true)
        })
    }
    
    func openDebug() {
        let module = AppModules.debug.build()
        executeFor(iPhone: {
            module.router.show(from: _view, embedInNavController: true)
        }, iPad: {
            module.router.showIPadForm(from: _view, needNavigationController: true)
        })
    }
    
    func openEdit(trip: WBTrip) {
        openEditTrip(trip)
    }
    
    func openAddTrip() {
        openEditTrip(nil)
    }
    
    func openDetails(trip: WBTrip) {
        let tabs = TripTabViewController(trip: trip)
        executeFor(iPhone: {
            _view.navigationController?.pushViewController(tabs, animated: true)
        }, iPad: {
            let nav = UINavigationController(rootViewController: tabs)
            nav.navigationBar.isTranslucent = false
            _view.splitViewController?.show(nav, sender: nil)
        })
    }
    
    func openNoTrips() {
        let vc = moduleStoryboard.instantiateViewController(withIdentifier: "NoTrips")
        _view.splitViewController?.show(vc, sender: nil)
    }
    
    private func openEditTrip(_ trip: WBTrip?) {
        executeFor(iPhone: {
            AppModules.editTrip.build().router.show(from: _view, embedInNavController: true, setupData: trip)
        }, iPad: {
            AppModules.editTrip.build().router.showIPadForm(from: _view, setupData: trip, needNavigationController: true)
        })
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension TripsRouter {
    var presenter: TripsPresenter {
        return _presenter as! TripsPresenter
    }
}
