//
//  HorizontalPickerItemCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 09/03/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

class HorizontalPickerItemCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        containerView.layer.cornerRadius = containerView.bounds.height/2
    }
    
    override func prepareForReuse() {
        label.text = nil
        label.attributedText = nil
    }
    
    override var isHighlighted: Bool {
        didSet {
            let color = isHighlighted ? AppTheme.buttonStyle1PressedColor : AppTheme.primaryColor
            containerView.backgroundColor = color
        }
    }
    
    func configureFor(any: Any) {
        if let string = any as? String {
            label.text = string
        } else if let attributedString = any as? NSAttributedString  {
            label.attributedText = attributedString
        } else {
            label.text = "\(any)"
        }
    }
    
    func confugureFor(string: String) {
        label.text = string
    }
    
    func configureFor(attributedString: NSAttributedString) {
        label.attributedText = attributedString
    }
    
    func widthFor(any: Any) -> CGFloat {
        configureFor(any: any)
        return calculateWidth()
    }
    
    func widthFor(string: String) -> CGFloat {
        confugureFor(string: string)
        return calculateWidth()
    }
    
    func widthFor(attributedString: NSAttributedString) -> CGFloat {
        configureFor(attributedString: attributedString)
        return calculateWidth()
    }
    
    private func calculateWidth() -> CGFloat {
        let result = label.sizeThatFits(CGSize(width: bounds.width, height: label.bounds.height)).width
        return result + containerView.bounds.height/2 + UI_MARGIN_16
    }
}
