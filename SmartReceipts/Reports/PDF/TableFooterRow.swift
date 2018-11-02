//
//  TableFooterRow.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 20/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class TableFooterRow: TableContentRow {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let styleColor = AppTheme.reportPDFStyleColor
        backgroundColor = styleColor.withAlphaComponent(0.2)
        contentLabel?.textColor = styleColor
        contentLabel?.font = PDFFontStyle.default.font
    }
}
