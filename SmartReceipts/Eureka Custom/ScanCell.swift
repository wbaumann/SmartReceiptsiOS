//
//  ScanCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 05/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Eureka

class ScanCell: Cell<Scan>, CellType {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var taxAmount: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
    public override func setup() {
        super.setup()
        height = { 72 }
    }
    
    public override func update() {
        super.update()
        if let scan = row().value {
            title.text = scan.merchant
            totalAmount.text = NSDecimalNumber(value: scan.totalAmount ?? 0).stringValue
            taxAmount.text = NSDecimalNumber(value: scan.taxAmount ?? 0).stringValue
            date.text = scan.date?.description
        }
    }
    
    private func row() -> ScanRow {
        return (row as! ScanRow)
    }
}


final class ScanRow: Row<ScanCell>, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<ScanCell>(nibName: "ScanCell")
    }
}
