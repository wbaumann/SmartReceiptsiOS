//
//  DescribedButtonCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24/02/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import Eureka

class DescribedButtonCell: ButtonCellOf<String> {
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var subtitle: UILabel!
    
    override func setup() {
        super.setup()
        textLabel?.isHidden = true
        update()
        
        let buttonArrowWidth: CGFloat = 51
        let estimateWidth = UIScreen.main.bounds.width - buttonArrowWidth - UI_MARGIN_16
        let estimateSize = CGSize(width: estimateWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let titleHeight = title.sizeThatFits(estimateSize).height
        let subtitleHeight = subtitle.sizeThatFits(estimateSize).height
        
        let margins = UI_MARGIN_16
        let cellHeight = titleHeight + subtitleHeight + margins
        height = { cellHeight }
    }
    
    override func update() {
        super.update()
        title.text = row().title
        subtitle.text = row().subtitle
    }
    
    private func row() -> DescribedButtonRow {
        return row as! DescribedButtonRow
    }
}


final class DescribedButtonRow: Row<DescribedButtonCell>, RowType {
    
    var subtitle: String?
    
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<DescribedButtonCell>(nibName: "DescribedButtonCell")
    }
}
