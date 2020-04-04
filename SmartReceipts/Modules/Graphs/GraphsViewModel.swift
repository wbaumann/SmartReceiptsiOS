//
//  GraphsViewModel.swift
//  SmartReceipts
//
//  Created Bogdan Evsenev on 04.04.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import UIKit

protocol GraphsViewModelProtocol {
    func moduleDidLoad()
}

class GraphsViewModel: GraphsViewModelProtocol {
    private var router: GraphsRouterProtocol
    
    init(router: GraphsRouterProtocol) {
        self.router = router
    }

    func moduleDidLoad() {

    }
}
