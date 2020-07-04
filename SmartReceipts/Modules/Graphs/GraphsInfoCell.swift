//
//  GraphInfoItemCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 02.06.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import Foundation

class GraphsInfoCell: UITableViewCell {
    @IBOutlet private weak var colorView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorView.layer.cornerRadius = UI_MARGIN_8/2
    }
    
    func configure(item: GraphsInfoDataSource.Item) -> Self {
        colorView.backgroundColor = item.color
        titleLabel.text = item.title
        valueLabel.text = item.total
        return self
    }
}
