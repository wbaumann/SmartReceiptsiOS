//
//  UIViewController+NavigationBar.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 29/05/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

extension UIViewController {
    
    func setTitle(_ title: String, subtitle: String, color: UIColor = UIColor.white) {
        let width: CGFloat = 100
        let height: CGFloat = 18
        let x: CGFloat = UIScreen.main.bounds.width/2 - width/2
        let titleView = UIView(frame: CGRect(x: x, y: 0, width: width, height: 44))
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 4, width: width, height: height))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.textColor = color
        titleLabel.text = title
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 24, width: width, height: height))
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = color
        subtitleLabel.text = subtitle
        
        setupLabels([titleLabel, subtitleLabel], toMiddleOf: titleView)
        
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        self.navigationItem.titleView = titleView
    }
    
    fileprivate func resizeLabels(_ labels: [UILabel]) {
        var maxWidth: CGFloat = 0
        
        // Calculate MAX width
        for label in labels {
            label.sizeToFit()
            maxWidth = max(maxWidth, label.bounds.width)
        }
        
        // Resize all labels to MAX width
        for label in labels {
            label.bounds = CGRect(x: label.bounds.origin.x, y: label.bounds.origin.y,
                                  width: maxWidth, height: label.bounds.height)
        }
    }
    
    fileprivate func setupLabels(_ labels: [UILabel], toMiddleOf view: UIView) {
        resizeLabels(labels)
        let titleWidth = UIScreen.main.bounds.width * 0.5
        view.bounds = CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y,
                                  width: titleWidth, height: view.bounds.height)
        for label in labels {
            label.center = CGPoint(x: view.bounds.width/2, y: label.center.y)
        }
    }

}
