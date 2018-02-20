//
//  DescribedSwitchCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/02/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import UIKit
import Eureka

final class InlinePickerButtonCell : Cell<String>, CellType {
    @IBOutlet fileprivate var titleLabel: UILabel!
    @IBOutlet fileprivate var valueLabel: UILabel!
    
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
        selectionStyle = .default
    }
}

class _InlinePickerButtonRow: Row<InlinePickerButtonCell> {
    
    override func updateCell() {
        super.updateCell()
    }
    
    required init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
    }
}

final class InlinePickerButtonRow: _InlinePickerButtonRow, RowType, InlineRowType {
    
    override var value: String? {
        didSet { inlineRow?.value = value }
    }
    
    var options = [String]() {
        didSet { inlineRow?.options = options }
    }
    
    func setupInlineRow(_ inlineRow: PickerButtonRow) {
        inlineRow.options = options
        inlineRow.value = value
    }
    
    typealias InlineRow = PickerButtonRow
    
    required init(tag: String?) {
        super.init(tag: tag)
        onExpandInlineRow { cell, row, _ in
            row.deselect()
        }
        onCollapseInlineRow { cell, row, _ in
            row.deselect()
        }
        cellProvider = CellProvider<InlinePickerButtonCell>(nibName: "InlinePickerButtonCell")
    }
    
    override func customDidSelect() {
        super.customDidSelect()
        !isDisabled ? toggleInlineRow() : ()
    }
}
