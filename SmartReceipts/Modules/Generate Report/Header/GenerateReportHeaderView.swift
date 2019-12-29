//
//  GenerateReportHeaderView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 29.12.2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit

class GenerateReportHeaderView: UIView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var configureButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = LocalizedString("report_info_generate")
        configureButton.layer.cornerRadius = 12
        configureButton.setTitle(LocalizedString("generate_report_tooltip"), for: .normal) 
    }
}
