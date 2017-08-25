//
//  NotifyMasterSplitViewController.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//


class NotifyMasterSplitViewController: UISplitViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        preferredDisplayMode = .allVisible
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewControllers.first?.viewWillAppear(animated)
    }
    
}
