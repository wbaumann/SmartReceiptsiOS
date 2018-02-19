//
//  PickerButtonCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 19/02/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import UIKit
import Eureka

final class PickerButtonCell : Cell<String>, CellType {
    @IBOutlet fileprivate var pickerView: UIPickerView!
    
    fileprivate let displayData = PickerDisplayData()
    
    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func update() {
        super.update()
    }
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        pickerView.delegate = displayData
        pickerView.dataSource = displayData
        height = { 140 }
        self.displayData.options = ["asdasd", "dd", "xwwe", "asdasd", "dd", "xwwe"]
    }
    
    override func didSelect() {
        
    }
    
    func row() -> PickerButtonRow {
        return row as! PickerButtonRow
    }
    
    @IBAction func buttonTap() {
        (row as? InlinePickerButtonRow)?.toggleInlineRow()
    }
}

class _PickerButtonRow: Row<PickerButtonCell> {
    
    override func updateCell() {
        
    }
    
    required init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
    }
}

final class PickerButtonRow: _PickerButtonRow, RowType {
    
    var options = [String]() {
        didSet {
            cell.displayData.options = options
            cell.pickerView.reloadAllComponents()
        }
    }
    
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<PickerButtonCell>(nibName: "PickerButtonCell")
    }
}

fileprivate class PickerDisplayData: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    var options = [String]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
}
