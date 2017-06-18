//
//  ReceiptsRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

class ReceiptsRouter: Router {
    
    func openDistances(for trip: WBTrip) {
        let module = Module.build(AppModules.tripDistances)
        executeFor(iPhone: {
            module.router.show(from: _view, embedInNavController: true, setupData: trip)
        }, iPad: {
            module.router.showIPadForm(from: _view, setupData: trip, needNavigationController: true)
        })
        
    }
    
    func openGenerateReport(for trip: WBTrip) {
        let module = Module.build(AppModules.generateReport)
        executeFor(iPhone: {
            module.router.show(from: _view, embedInNavController: true, setupData: trip)
        }, iPad: {
            module.router.showIPadForm(from: _view, setupData: trip, needNavigationController: true)
        })
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptsRouter {
    var presenter: ReceiptsPresenter {
        return _presenter as! ReceiptsPresenter
    }
}
