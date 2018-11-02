//
//  TableHeaderRow.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

@IBDesignable
class TableHeaderRow: TableContentRow {
    @IBOutlet private var bottomSeparatorView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let styleColor = AppTheme.reportPDFStyleColor
        contentLabel?.textColor = styleColor
        backgroundColor = styleColor.withAlphaComponent(0.2)
        bottomSeparatorView?.backgroundColor = styleColor
    }
}
