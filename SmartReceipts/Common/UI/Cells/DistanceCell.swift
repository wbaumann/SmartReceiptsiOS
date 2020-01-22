//
//  DistanceCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/08/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import UIKit

class DistanceCell: SyncableTableCell {
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var destinationLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    
    @discardableResult
    func configure(distance: Distance) -> Self {
        distanceLabel.text = Price.stringFrom(amount: distance.distance)
        destinationLabel.text = distance.location
        totalLabel.text = distance.totalRate().currencyFormattedPrice()
        return self
    }
}
