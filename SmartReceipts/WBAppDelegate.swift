//
//  WBAppDelegate.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 17/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

extension WBAppDelegate {
    
    func enableAnalytics() {
        AnalyticsManager.sharedManager.register(newService: GoogleAnalytics())
        AnalyticsManager.sharedManager.register(newService: FirebaseAnalytics())
        AnalyticsManager.sharedManager.register(newService: AnalyticsLogger())
    }
    
    func showTrips() {
        let module = Module.build(AppModules.trips)
        executeFor(iPhone: {
            module.router.show(inWindow: self.window, embedInNavController: true)
        }, iPad: {
            let splitViewController = UISplitViewController()
            splitViewController.preferredDisplayMode = .allVisible
            
            let storyboard = UIStoryboard(name: "Trips", bundle: nil)
            let detail = storyboard.instantiateViewController(withIdentifier: "NoTrips")
            let master = UINavigationController(rootViewController: module.view)
            
            splitViewController.viewControllers = [master, detail]
            self.window.rootViewController = splitViewController
        })
    }

}
