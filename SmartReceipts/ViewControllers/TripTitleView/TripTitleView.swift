//
//  TripTitleView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 23.12.2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation

class TripTitleView: UIView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var arrrowImageView: UIImageView!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    override var tintColor: UIColor! {
        didSet {
            titleLabel.textColor = tintColor
            arrrowImageView.tintColor = tintColor
            subtitleLabel.textColor = tintColor.withAlphaComponent(0.5)
        }
    }
    
    func set(title: String, subtitle: String?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle == nil
    }
}
