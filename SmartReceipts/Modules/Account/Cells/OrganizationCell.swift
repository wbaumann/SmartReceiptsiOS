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
    @IBOutlet private weak var importButton: UIButton!
    @IBOutlet private weak var uploadButton: UIButton!
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var infoContainer: UIView!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var infoIconView: UIImageView!
    
    private var organization: OrganizationModel!
    
    typealias OrganizationAction = ((OrganizationModel)->Void)
    var onApplyTap: OrganizationAction? = nil
    var onUploadTap: OrganizationAction? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roleLabel.layer.borderWidth = 1
        roleLabel.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
        roleLabel.layer.cornerRadius = 12.5
        
        infoContainer.layer.cornerRadius = 8
        infoContainer.layer.masksToBounds = true
        
        uploadButton.isHidden = true
        
        importButton.apply(style: .main)
        uploadButton.apply(style: .main)
        cardView.apply(style: .card)
        
        importButton.setTitle(LocalizedString("organization_update"), for: .normal)
        uploadButton.setTitle(LocalizedString("organization.settings.upload"), for: .normal)
        
        importButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.onApplyTap?(self.organization)
            }).disposed(by: bag)
        
        uploadButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.onUploadTap?(self.organization)
            }).disposed(by: bag)
    }
    
    func configureCell(organization: OrganizationModel, role: OrganizationUser.Role, synced: Bool) -> Self {
        self.organization = organization
        titleLabel.text = organization.name
        roleLabel.text = role.title.uppercased()
        
        infoContainer.backgroundColor = synced ? #colorLiteral(red: 0.8431372549, green: 0.9725490196, blue: 0.8392156863, alpha: 1) : #colorLiteral(red: 0.9725490196, green: 0.9529411765, blue: 0.8392156863, alpha: 1)
        infoLabel.textColor = synced ? #colorLiteral(red: 0.4352941176, green: 0.6156862745, blue: 0.3529411765, alpha: 1) : #colorLiteral(red: 0.5921568627, green: 0.5058823529, blue: 0.3215686275, alpha: 1)
        infoIconView.image = synced ? #imageLiteral(resourceName: "checkmark") : #imageLiteral(resourceName: "alert_icon")
        
        importButton.isHidden = synced
        uploadButton.isHidden = role == .user
        
        infoLabel.text = synced
            ? LocalizedString("organization_settings_match")
            : LocalizedString("organization_settings_doesnt_match")
        
        return self
    }
}

extension OrganizationUser.Role {
    var title: String {
        switch self {
        case .admin: return LocalizedString("organization.user.role.admin")
        case .supportAdmin: return LocalizedString("organization.user.role.admin")
        case .user: return LocalizedString("organization.user.role.user")
        }
    }
}
