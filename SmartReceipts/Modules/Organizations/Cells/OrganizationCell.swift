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
    @IBOutlet private weak var membersLabel: UILabel!
    @IBOutlet private weak var roleLabel: UILabel!
    @IBOutlet private weak var applyButton: UIButton!
    @IBOutlet private weak var cardView: UIView!
    
    private var organization: Organization!
    
    typealias OrganizationApplyAction = ((Organization)->Void)
    var onApplyTap: OrganizationApplyAction? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyButton.apply(style: .main)
        cardView.apply(style: .card)
        
        applyButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.onApplyTap?(self.organization)
            }).disposed(by: bag)
        
    }
    
    func configureCell(organization: Organization, role: OrganizationUser.Role) {
        self.organization = organization
        titleLabel.text = organization.name
        membersLabel.text = "Members count: \(organization.users.count)"
        roleLabel.text = role.title
    }
}

extension OrganizationUser.Role {
    var title: String {
        switch self {
        case .admin: return LocalizedString("organization.user.role.admin")
        }
    }
}
