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
        title.text = nil
        subtitle.text = nil
        
        selectionStyle = .none
        switcher.onTintColor = AppTheme.primaryColor
        switcher.addTarget(self, action: #selector(DescribedSwitchCell.switchAction), for: .valueChanged)
        
        update()
        
        let switchWidth: CGFloat = 51
        let estimateWidth = UIScreen.main.bounds.width - switchWidth - UI_MARGIN_16 * 2 + UI_MARGIN_8
        let estimateSize = CGSize(width: estimateWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let titleHeight = title.sizeThatFits(estimateSize).height
        let subtitleHeight = subtitle.sizeThatFits(estimateSize).height
        
        let margins = UI_MARGIN_16 * 2
        let cellHeight = titleHeight + subtitleHeight + margins
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
        guard let rowValue = row().value else { return }
        switcher.isOn = rowValue
        updateSubtitle()
    }
    
    func switchAction() {
        row.value = switcher.isOn
        updateSubtitle()
    }
    
    private func updateSubtitle() {
        if let text = switcher.isOn ? row().onSubtitle : row().offSubtitle {
            subtitle.text = text
        }
    }
    
    private func row() -> DescribedSwitchRow {
        return (row as! DescribedSwitchRow)
    }
    
}


final class DescribedSwitchRow: Row<DescribedSwitchCell>, RowType {
    var onSubtitle: String?
    var offSubtitle: String?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<DescribedSwitchCell>(nibName: "DescribedSwitchCell")
    }
}

