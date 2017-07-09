//
//  CustomSegmentedCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Eureka
import RxSwift

public class PurchaseButtonCell: Cell<String>, CellType {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    
    private let bag = DisposeBag()
    
    public override func setup() {
        super.setup()
        super.selectionStyle = .none
    }
    
    public override func update() {
        super.update()
        titleLabel.text = row.title
        subtitleLabel.text = row.value
        selectionStyle = .default
    }
    
    public override func didSelect() {
        super.didSelect()
        row.deselect()
    }
}

public final class PurchaseButtonRow: Row<PurchaseButtonCell>, RowType{
    
    private var _options = [String]()
    
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<PurchaseButtonCell>(nibName: "PurchaseButtonCell")
    }

    public override var value: String? {
        get { return super.value }
        set {
            super.value = newValue
            let indicator = cell.activityIndicator
            newValue == nil ? indicator?.startAnimating() : indicator?.stopAnimating()
        }
    }
}
