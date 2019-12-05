//
//  ReceiptsSectionHeader.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 04.12.2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit

class ReceiptsSectionHeader: UITableViewHeaderFooterView {
    
    private lazy var label: UILabel = {
        let label = BorderedLabel(frame: .zero)
        label.backgroundColor = UIColor.srBlack.withAlphaComponent(0.08)
        label.textColor = UIColor.srBlack.withAlphaComponent(0.3)
        label.font = .semibold11
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func configure(title: String, subtitle: String) -> Self {
        label.text = [title, subtitle].joined(separator: "  |  ")
        label.sizeToFit()
        label.frame.size.height = 21
        label.layer.cornerRadius = label.bounds.height/2
        return self
    }
    
    private func commonInit() {
        textLabel?.isHidden = true
        addSubview(label)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.center = .init(x: bounds.width/2, y: bounds.height/2)
    }
}
