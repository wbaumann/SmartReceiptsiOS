//
//  GraphsAssembly.swift
//  SmartReceipts
//
//  Created Bogdan Evsenev on 04.04.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import UIKit

class GraphsAssembly {

    func build() -> UIViewController {
        let view = GraphsViewController()
        let router = GraphsRouter()
        let viewModel = GraphsViewModel(router: router)
        
        view.viewModel = viewModel
        router.moduleViewController = view
        
        return view
    }

}
