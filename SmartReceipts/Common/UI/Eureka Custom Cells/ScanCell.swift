//
//  ScanCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 05/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Eureka

class ScanCell: Cell<ScanResult>, CellType {
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
        guard let scan = row().value else { return }
        clear()
        
        title.text = scan.recognition?.result.data.merchantName?.data
        if let amount = scan.recognition?.result.amount { totalAmount.text = NSDecimalNumber(value: amount).stringValue }
        if let tax = scan.recognition?.result.tax { taxAmount.text = NSDecimalNumber(value: tax).stringValue }
        if let scanDate = scan.recognition?.result.data.date?.data { date.text = scanDate.dayString() }
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
