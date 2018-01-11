//
//  DescribedSwitchCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/01/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Eureka
import Foundation

class DescribedSwitchCell: Cell<Bool>, CellType {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    
    public override func setup() {
        super.setup()
        
        selectionStyle = .none
        switcher.onTintColor = AppTheme.primaryColor
        switcher.addTarget(self, action: #selector(DescribedSwitchCell.switchAction), for: .valueChanged)
        
        update()
        title.sizeToFit()
        subtitle.sizeToFit()
        
        let cellHeight = title.bounds.height + subtitle.bounds.height + 24
        height = { cellHeight }
    }
    
    override var isUserInteractionEnabled: Bool {
        get { return super.isUserInteractionEnabled }
        set {
            super.isUserInteractionEnabled = newValue
            for view in subviews {
                view.alpha = newValue ? 1.0 : 0.5
            }
        }
    }
    
    public override func update() {
        super.update()
        title.text = row().title
        subtitle.text = row().subtitle
        if let rowValue = row().value { switcher.isOn = rowValue }
    }
    
    func switchAction() {
        row.value = switcher.isOn
    }
    
    private func row() -> DescribedSwitchRow {
        return (row as! DescribedSwitchRow)
    }
}


final class DescribedSwitchRow: Row<DescribedSwitchCell>, RowType {
    var subtitle: String?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<DescribedSwitchCell>(nibName: "DescribedSwitchCell")
    }
}

