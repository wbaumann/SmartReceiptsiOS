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
    
    func configureCell(subscription: SubscriptionModel) -> Self {
        titleLabel.text = subscription.productName
        let formatter = WBDateFormatter()
        if Calendar.current.isDateInToday(subscription.expiresAt) {
            formatter.formatter.timeStyle = .short
        }
        let formattedDate = formatter.formattedDate(subscription.expiresAt, in: NSTimeZone.local)
        expiresLabel.text = String(format: LocalizedString("settings_purchase_subscription_valid_until_label_base"), formattedDate!)
        return self
    }
}
