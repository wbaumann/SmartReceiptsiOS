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
            clear()
            
            title.text = scan.merchant
            if let amount = scan.totalAmount { totalAmount.text = NSDecimalNumber(value: amount).stringValue }
            if let tax = scan.taxAmount { taxAmount.text = NSDecimalNumber(value: tax).stringValue }
            if let scanDate = scan.date { date.text = scanDate.dayString() }
        }
    }
    
    func clear() {
        title.text = nil
        totalAmount.text = nil
        taxAmount.text = nil
        date.text = nil
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
