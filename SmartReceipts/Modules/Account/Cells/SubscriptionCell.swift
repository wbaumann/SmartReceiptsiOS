//
//  SubscriptionCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 09/08/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift

class SubscriptionCell: UITableViewCell {
    private let bag = DisposeBag()
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var expiresLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(subscription: SubscriptionModel) {
        titleLabel.text = "Smart Receipts Plus"
        expiresLabel.text = "Expires at: \(subscription.expiresAt)"
    }
}
