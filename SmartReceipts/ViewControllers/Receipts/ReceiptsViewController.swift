//
//  ReceiptsViewController.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Viperit

extension WBReceiptsViewController {
    // Distances Module temporary opens from extension before WBReceiptsViewController Swift migration
    func openDistances() {
        let module = Module.build(AppModules.tripDistances)
        module.router.show(from: self, embedInNavController: true, setupData: nil)
    }
}
