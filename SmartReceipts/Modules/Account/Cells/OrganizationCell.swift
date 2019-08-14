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
