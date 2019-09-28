//
//  TripDistancesRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

class TripDistancesRouter: Router {
    func showEditDistance(with data: Any?) {
        let module = AppModules.editDistance.build()
        module.router.show(from: _view, embedInNavController: true, setupData: data)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension TripDistancesRouter {
    var presenter: TripDistancesPresenter {
        return _presenter as! TripDistancesPresenter
    }
}
