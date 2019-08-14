//
//  UserCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 09/08/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift

class UserCell: UITableViewCell {
    private let bag = DisposeBag()
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var logoutButton: UIButton!
    
    var onLogoutTap: VoidBlock? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "Logged in as"
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.apply(style: .mainTextOnly)
        logoutButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.onLogoutTap?()
            }).disposed(by: bag)
    }
    
    func configureCell(user: User) -> Self {
        emailLabel.text = user.email
        return self
    }
}
