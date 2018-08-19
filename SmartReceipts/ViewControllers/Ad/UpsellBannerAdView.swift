//
//  UpsellBannerAdView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/01/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class UpsellBannerAdView: UIView {
    private weak var button: UIButton!
    
    var bannerTap: Observable<Void> {
        return button.rx.tap.asObservable()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    private func commonInit() {
        backgroundColor = AppTheme.primaryColor
        
        let button = UIButton(frame: CGRect.zero)
        
        addSubview(button)
        
        button.setTitle(LocalizedString("missing_ad_suggest_removal_upsell_ios"), for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = AppTheme.boldFont
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: UI_MARGIN_16, bottom: 0, right: UI_MARGIN_16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        self.button = button
    }
}
