//
//  ReceiptsViewController.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Viperit

extension WBReceiptsViewController {
    // Distances Module temporary opens from extension before WBReceiptsViewController Swift 
    func openDistances(for trip: WBTrip) {
        let module = Module.build(AppModules.tripDistances)
        module.router.show(from: self, embedInNavController: true, setupData: trip)
    }
    
    // Generate Report Module temporary opens from extension before WBReceiptsViewController Swift
    func openGenerateReport(for trip: WBTrip) {
        let module = Module.build(AppModules.generateReport)
        module.router.show(from: self, embedInNavController: true, setupData: trip)
    }
}
