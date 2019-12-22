//
//  TripCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/08/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import UIKit

class TripCell: SyncableTableCell {
    @IBOutlet private(set) weak var priceLabel: UILabel!
    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var dateLabel: UILabel!
    @IBOutlet private(set) weak var selectionIndicator: UIView!
    
    private let dateFormatter = WBDateFormatter()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionIndicator.layer.cornerRadius = 5
    }
    
    @discardableResult
    func configure(trip: WBTrip, selected: Bool) -> Self {
        selectionIndicator.isHidden = !selected
        nameLabel.textColor = selected ? #colorLiteral(red: 0.2020273507, green: 0.1010685936, blue: 0.5962305665, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        priceLabel.text = trip.formattedPrice()
        nameLabel.text = trip.name
        
        let from = dateFormatter.formattedDate(trip.startDate, in: trip.startTimeZone)!
        let to = dateFormatter.formattedDate(trip.endDate, in: trip.endTimeZone)!
        dateLabel.text = "\(from) ⇀ \(to)"
        let state = ModelSyncState.modelState(modelChangeDate: trip.lastLocalModificationTime)
        setState(state)
        
        return self
    }
}
