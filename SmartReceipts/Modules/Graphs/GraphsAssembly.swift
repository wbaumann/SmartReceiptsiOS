//
//  GraphsAssembly.swift
//  SmartReceipts
//
//  Created Bogdan Evsenev on 04.04.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import UIKit

class GraphsAssembly {

    func build(trip: WBTrip) -> UIViewController {
        let view = GraphsViewController.create()
        let router = GraphsRouter()
        let viewModel = GraphsViewModel(router: router, trip: trip)
        
        view.viewModel = viewModel
        router.moduleViewController = view
        let nav = UINavigationController(rootViewController: view)
        nav.modalPresentationStyle = .fullScreen
        
        return nav
    }
}

extension GraphsAssembly {
    enum PeriodSelection {
        case report, daily, weekly, monthly
    }

    enum ModelSelection {
        case categories, paymentMethods, dates
    }
}
