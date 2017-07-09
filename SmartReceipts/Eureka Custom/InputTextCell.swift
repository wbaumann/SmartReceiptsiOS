//
//  InputTextCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Eureka

public class InputTextCell: TextCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var valueField: UITextField!
    
    public override func setup() {
        textField = valueField
        titleLabel = label
        super.setup()
    }
    
    public override func update() {
        super.update()
        titleLabel?.text = row.title
        textField?.text = row.value
    }
    
    private func row() -> InputTextRow {
        return (row as! InputTextRow)
    }
}


public final class InputTextRow: Row<InputTextCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<InputTextCell>(nibName: "InputTextCell")
    }
}
