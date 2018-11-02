//
//  ReceiptCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/08/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import UIKit

class ReceiptCell: SyncableTableCell {
    @IBOutlet private(set) weak var priceLabel: UILabel!
    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var dateLabel: UILabel!
    @IBOutlet private(set) weak var categoryLabel: UILabel!
    @IBOutlet private(set) weak var markerLabel: UILabel!
    @IBOutlet private(set) weak var priceWidthConstraint: NSLayoutConstraint!
}
