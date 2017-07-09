//
//  CustomSegmentedCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Eureka

public class CustomSegmentedCell: Cell<Int>, CellType {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    public override func setup() {
        super.setup()
        super.selectionStyle = .none
    }
    
    public override func update() {
        super.update()
        titleLabel.text = row.title
        segmentedControl.selectedSegmentIndex = row.value!
    }
    
    @IBAction private func onSegmentChange() {
        row.value = segmentedControl.selectedSegmentIndex
    }
}


public final class CustomSegmentedRow: Row<CustomSegmentedCell>, RowType{
    
    private var _options = [String]()
    
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<CustomSegmentedCell>(nibName: "CustomSegmentedCell")
    }
    
    var options: [String] {
        get { return _options }
        set {
            _options = newValue
            cell.segmentedControl.removeAllSegments()
            _options.enumerated().forEach { offset, item in
                cell.segmentedControl.insertSegment(withTitle: item, at: offset, animated: false)
            }
        }
    }
    
    var selectedOption: String {
        get { return _options[cell.segmentedControl.selectedSegmentIndex] }
    }

}
