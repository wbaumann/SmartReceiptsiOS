//
//  FetchedPlaceholderView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 28/05/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

class FetchedPlaceholderView: UIView {
    
    private let MARGIN: CGFloat = 25
    
    private var placeholderLabel: UILabel!
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        placeholderLabel = UILabel(frame: CGRect.zero)
        placeholderLabel.numberOfLines = 0
        placeholderLabel.font = UIFont.systemFont(ofSize: 15)
        placeholderLabel.textColor = UIColor.black
        setTitle(title)
        
        addSubview(placeholderLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTitle(_ title: String) {
        placeholderLabel.text = title
        let sizeBefore = CGSize(width: bounds.width - MARGIN * 2, height: 0)
        let size = placeholderLabel.sizeThatFits(sizeBefore)
        placeholderLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        placeholderLabel.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
    }
    
    override func layoutSubviews() {
        placeholderLabel.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
    }
}
