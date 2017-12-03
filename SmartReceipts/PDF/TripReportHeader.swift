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
    
    func appendRow(_ row: String) {
        let label = UILabel(frame: rowPrototype.bounds)
        label.numberOfLines = 0
        label.font = PDFFontStyle.default.font
        label.text = row
        addSubview(label)
        adjustLabelHeightToFitAndPosition(label: label)
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
}

