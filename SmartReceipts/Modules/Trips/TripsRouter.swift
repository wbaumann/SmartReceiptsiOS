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

private let USER_GUIDE_URL = "https://www.smartreceipts.co/guide"

class TripsRouter: Router {
    
    private let moduleStoryboard = UIStoryboard(name: "Trips", bundle: nil)
    
    func openSettings() {
        let module = AppModules.settings.build()
        openModal(module: module)
    }
    
    func openPrivacySettings() {
        let module = AppModules.settings.build()
        module.presenter.setupView(data: ShowSettingsOption.privacySection)
        openModal(module: module)
    }
    
    func openBackup() {
        let module = AppModules.backup.build()
        openModal(module: module)
    }
    
    func openDebug() {
        let module = AppModules.debug.build()
        openModal(module: module)
    }
    
    func openAuth() -> AuthModuleInterface {
        let module = AppModules.auth.build()
        openModal(module: module)
        return module.interface(AuthModuleInterface.self)
    }
    
    func openAutoScans() {
        AnalyticsManager.sharedManager.record(event: Event.Navigation.OcrConfiguration)
        let module = AppModules.OCRConfiguration.build()
        openModal(module: module)
    }
    
    func openUserGuide() {
        AnalyticsManager.sharedManager.record(event: Event.Navigation.OcrConfiguration)
        let safari = SFSafariViewController(url: URL(string: USER_GUIDE_URL)!, entersReaderIfAvailable: true)
        _view.present(safari, animated: true, completion: nil)
    }
    
    func openEdit(trip: WBTrip) {
        openEditTrip(trip)
    }
    
    func openAddTrip() {
        openEditTrip(nil)
    }
    
    func openDetails(trip: WBTrip) {
        let tabs = TripTabViewController(trip: trip)
        _view.navigationController?.pushViewController(tabs, animated: true)
    }
    
    func openNoTrips() {
        let vc = moduleStoryboard.instantiateViewController(withIdentifier: "NoTrips")
        _view.splitViewController?.show(vc, sender: nil)
    }
    
    private func openEditTrip(_ trip: WBTrip?) {
        AppModules.editTrip.build().router.show(from: _view, embedInNavController: true, setupData: trip)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension TripsRouter {
    var presenter: TripsPresenter {
        return _presenter as! TripsPresenter
    }
}
