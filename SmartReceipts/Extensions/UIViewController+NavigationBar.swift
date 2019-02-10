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
        
        let subtitleLabel = UILabel(frame: .zero)
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = color
        subtitleLabel.text = subtitle
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.alignment = .center
        stackView.axis = .vertical
        
        navigationItem.titleView = stackView
    }
}
