//
//  OrganizationCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 02/08/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift

class OrganizationCell: UITableViewCell {
    private let bag = DisposeBag()
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var roleLabel: BorderedLabel!
    @IBOutlet private weak var applyButton: UIButton!
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var infoContainer: UIView!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var infoIconView: UIImageView!
    
    private var organization: OrganizationModel!
    
    typealias OrganizationApplyAction = ((OrganizationModel)->Void)
    var onApplyTap: OrganizationApplyAction? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roleLabel.layer.borderWidth = 1
        roleLabel.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
        roleLabel.layer.cornerRadius = roleLabel.bounds.height/2
        
        infoContainer.layer.cornerRadius = 8
        infoContainer.layer.masksToBounds = true
        
        applyButton.apply(style: .main)
        cardView.apply(style: .card)
        
        applyButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.onApplyTap?(self.organization)
            }).disposed(by: bag)
        
    }
    
    func configureCell(organization: OrganizationModel, role: OrganizationUser.Role) -> Self {
        self.organization = organization
        titleLabel.text = organization.name
        roleLabel.text = role.title.uppercased()
        
        
        //test
        let isSynced = false
        
        infoContainer.backgroundColor = isSynced ? #colorLiteral(red: 0.8431372549, green: 0.9725490196, blue: 0.8392156863, alpha: 1) : #colorLiteral(red: 0.9725490196, green: 0.9529411765, blue: 0.8392156863, alpha: 1)
        infoLabel.textColor = isSynced ? #colorLiteral(red: 0.4352941176, green: 0.6156862745, blue: 0.3529411765, alpha: 1) : #colorLiteral(red: 0.5921568627, green: 0.5058823529, blue: 0.3215686275, alpha: 1)
        infoIconView.image = isSynced ? #imageLiteral(resourceName: "checkmark") : #imageLiteral(resourceName: "alert_icon")
        
        infoLabel.text = isSynced ?
            LocalizedString("organization_settings_match")
            : LocalizedString("organization_settings_doesnt_match")
        
        return self
    }
}

extension OrganizationUser.Role {
    var title: String {
        switch self {
        case .admin: return LocalizedString("organization.user.role.admin")
        }
    }
}
