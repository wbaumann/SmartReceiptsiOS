//
//  UIViewController+NavigationBar.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 29/05/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

extension UIViewController {
    
    func setTitle(_ title: String, subtitle: String, color: UIColor = .white) {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.textColor = color
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: .zero)
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = color
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.alignment = .center
        stackView.axis = .vertical
        
        let width = max(titleLabel.bounds.width, subtitleLabel.bounds.width)
        let height = titleLabel.bounds.height + subtitleLabel.bounds.height
        stackView.frame.size = .init(width: width, height: height)
        
        navigationItem.titleView = stackView
    }
}
