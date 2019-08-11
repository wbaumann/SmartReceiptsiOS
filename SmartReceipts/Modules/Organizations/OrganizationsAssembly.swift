//
//  OrganizationsAssembly.swift
//  SmartReceipts
//
//  Created Bogdan Evsenev on 29/07/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit

//typealias OrganizationsModule = (view: UIViewController, output: Action)

class OrganizationsAssembly: ModuleAssembly {

    func build() -> UIViewController {
        let view = OrganizationsViewController.create()
        let router = OrganizationsRouter()
        
        let viewModel = OrganizationsViewModel(
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
