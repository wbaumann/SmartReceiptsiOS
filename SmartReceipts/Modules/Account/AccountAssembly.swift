//
//  AccountAssembly.swift
//  SmartReceipts
//
//  Created Bogdan Evsenev on 29/07/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit

//typealias AccountModule = (view: UIViewController, output: Action)

class AccountAssembly: ModuleAssembly {

    func build() -> UIViewController {
        let view = AccountViewController.create()
        let router = AccountRouter()
        
        let viewModel = AccountViewModel(
            router: router,
            organizationsService: serviceFactory.organizationService,
            authService: serviceFactory.authService,
            purhcaseService: serviceFactory.purchaseService
        )
        
        view.viewModel = viewModel
        router.moduleViewController = view
        
        return view
    }

}
