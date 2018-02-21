//
//  DescribedSwitchCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/02/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import UIKit
import Eureka
import RxSwift

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
        titleLabel.text = row.title
        valueLabel.text = row.value
    }
    
    override func setup() {
        super.setup()
        selectionStyle = .default
        titleLabel?.font = AppTheme.boldFont
        valueLabel?.font = AppTheme.boldFont
        valueLabel?.textColor = AppTheme.primaryColor
    }
}

class _InlinePickerButtonRow: Row<InlinePickerButtonCell> {
    
    override func updateCell() {
        super.updateCell()
    }
    
    required init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = { [unowned self] value in
            self.cell.valueLabel.text = value
            self.value = value
            return value
        }
    }
}

final class InlinePickerButtonRow: _InlinePickerButtonRow, RowType, InlineRowType {
    private let bag = DisposeBag()
    private let tapSubject = PublishSubject<Void>()
    
    var buttonTap: Observable<Void> {
        return tapSubject.asObservable()
    }
    
    var buttonTitle: String? {
        didSet { inlineRow?.buttonTitle = buttonTitle }
    }
    
    override var value: String? {
        didSet { inlineRow?.value = value }
    }
    
    var options = [String]() {
        didSet { inlineRow?.options = options }
    }
    
    func setupInlineRow(_ inlineRow: PickerButtonRow) {
        inlineRow.options = options
        inlineRow.value = value
        inlineRow.buttonTitle = buttonTitle
        inlineRow.displayValueFor = displayValueFor
        inlineRow.buttonTap?
            .bind(onNext: { [unowned self] in
                self.tapSubject.onNext()
            }).disposed(by: bag)
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
