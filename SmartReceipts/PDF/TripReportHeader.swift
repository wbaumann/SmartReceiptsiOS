//
//  TripReportHeader.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

fileprivate let HeaderRowsSpacing: CGFloat = 8

class TripReportHeader: UIView {
    @IBOutlet var tripNameLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var rowPrototype: UILabel!
    
    var yOffset: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tripNameLabel.font = PDFFontStyle.title.font
        rowPrototype.removeFromSuperview()
    }
    
    func setTrip(name: String) {
        tripNameLabel.text = name
        adjustLabelHeightToFitAndPosition(label: tripNameLabel)
    }
    
    func appendRow(_ row: String, style: PDFFontStyle = .default) {
        let label = makeRowCopy()
        label.removeConstraints(label.constraints)
        label.numberOfLines = 0
        label.font = style.font
        label.text = row
        adjustLabelHeightToFitAndPosition(label: label)
        stackView.addArrangedSubview(label)
    }
    
    private func adjustLabelHeightToFitAndPosition(label: UILabel) {
        let size = CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude)
        let fitHeight = label.sizeThatFits(size).height
        yOffset += HeaderRowsSpacing
        
        var labelFrame = label.frame
        labelFrame.origin.y = yOffset
        labelFrame.size.height = fitHeight
        label.frame = labelFrame
        
        yOffset += fitHeight
        
        var myFrame = frame
        myFrame.size.height = yOffset
        frame = myFrame
    }
    
    private func makeRowCopy() -> UILabel {
        let data = NSKeyedArchiver.archivedData(withRootObject: rowPrototype)
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! UILabel
    }
}

