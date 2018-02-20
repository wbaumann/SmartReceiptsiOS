//
//  PickerButtonCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 19/02/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import UIKit
import Eureka

fileprivate let BUTTON_CORNER_RADIUS: CGFloat = 5

final class PickerButtonCell : Cell<String>, CellType {
    @IBOutlet fileprivate var pickerView: UIPickerView!
    @IBOutlet fileprivate var button: UIButton!
    
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
        displayData.row = row()
        pickerView.delegate = displayData
        pickerView.dataSource = displayData
        pickerView.showsSelectionIndicator = true
        button.layer.cornerRadius = BUTTON_CORNER_RADIUS
        height = { 180 }
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
    }
}

final class PickerButtonRow: _PickerButtonRow, RowType {
    var buttonTitle: String? {
        get { return cell.button.title(for: .normal) }
        set { cell.button.setTitle(newValue, for: .normal) }
    }
    
    override var value: String? {
        get { return options[cell.pickerView.selectedRow(inComponent: 0)] }
        set {
            if newValue != nil, let index = options.index(of: newValue!)  {
                cell.pickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }
    
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
    weak var row: PickerButtonRow?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        _ = self.row?.displayValueFor?(options[row])
    }
}
