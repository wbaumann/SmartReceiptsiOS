//
//  AccountViewController.swift
//  SmartReceipts
//
//  Created Bogdan Evsenev on 29/07/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AccountViewController: UIViewController, Storyboardable {
    var viewModel: AccountViewModelProtocol!
    private let bag = DisposeBag()
    private let dataSource = AccountDataSource()
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var authPlaceholder: UIView!
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        localize()
        bind()
        
        viewModel.moduleDidLoad()
    }
    
    private func setupViews() {
        tableView.refreshControl = refreshControl
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.beginRefreshing(animated: false)
    }
    
    private func bind() {
        tableView.refreshControl?.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.onRefresh)
            .disposed(by: bag)
        
        loginButton.rx.tap
            .bind(to: viewModel.onLoginTap)
            .disposed(by: bag)
        
        viewModel.dataSet
            .subscribe(onNext: { [weak self] dataSet in
                self?.refreshControl.endRefreshing()
                self?.dataSource.update(dataSet: dataSet)
                self?.tableView.reloadData()
            }).disposed(by: bag)
        
        viewModel.isAuthorized
            .subscribe(onNext: { [weak self] in
                self?.authPlaceholder.isHidden = $0
            }).disposed(by: bag)
    }
    
    private func localize() {
        title = "My Account"
    }
    
}

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch cell {
        case let cell as UserCell: cell.onLogoutTap = { [weak self] in self?.logoutTap() }
        case let cell as OrganizationCell: cell.onApplyTap = { [weak self] in self?.applyTap(organiztion: $0) }
        case let cell as OCRCell: cell.onConfigureTap = { [weak self] in self?.onConfigureOcrTap() }
        default: break
        }
    }
    
    // MARK: Private actions for cells
    
    private func logoutTap() {
        viewModel.onLogoutTap.onNext()
    }
    
    private func applyTap(organiztion: OrganizationModel) {
        viewModel.onApplySettings.onNext(organiztion.appSettings)
    }
    
    private func onConfigureOcrTap() {
        viewModel.onOcrConfigureTap.onNext()
    }
}
