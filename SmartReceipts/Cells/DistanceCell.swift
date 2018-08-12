//
//  DistanceCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/08/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import UIKit

class DistanceCell: SyncableTableCell {
    @IBOutlet private(set) weak var distanceLabel: UILabel!
    @IBOutlet private(set) weak var destinationLabel: UILabel!
    @IBOutlet private(set) weak var totalLabel: UILabel!
    @IBOutlet private(set) weak var dateLabel: UILabel!
    @IBOutlet private(set) weak var priceWidthConstraint: NSLayoutConstraint!
    
    func setPriceLabelWidth(_ width: CGFloat) {
        priceWidthConstraint.constant = width
        layoutIfNeeded()
    }
}
