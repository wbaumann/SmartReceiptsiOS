//
//  NoTripsViewController.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit

class NoTripsViewController: UIViewController {
    
    @IBOutlet private weak var noTripsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        noTripsLabel.text = LocalizedString("no.trips.empty.message")
    }

}
