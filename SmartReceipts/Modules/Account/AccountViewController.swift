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
        loginButton.apply(style: .mainBig)
        
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
        title = LocalizedString("menu_main_my_account")
    }
    
}

extension AccountViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if dataSource.tableView(tableView, titleForHeaderInSection: section) == nil { return 0.1 }
        return Constants.headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = dataSource.tableView(tableView, titleForHeaderInSection: section) else { return nil }
        let label = UILabel(frame: .init(x: UI_MARGIN_16, y: UI_MARGIN_16))
        label.text = title
        label.font = .semibold17
        label.sizeToFit()
        
        let container = UIView()
        container.addSubview(label)
        return container
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constants.footerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section < tableView.numberOfSections - 1 else { return nil }
        
        let separatorFrame = CGRect(x: UI_MARGIN_16, y: 0, width: tableView.bounds.width, height: Constants.footerHeight)
        let footer = UIView(frame: separatorFrame)
        footer.backgroundColor = Constants.footerColor
        
        let container = UIView()
        container.addSubview(footer)
        return container
    }
    
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
        viewModel.onImportSettings.onNext(organiztion.appSettings)
    }
    
    private func onConfigureOcrTap() {
        viewModel.onOcrConfigureTap.onNext()
    }
}

private enum Constants {
    static let headerHeight: CGFloat = 52
    static let footerHeight: CGFloat = 0.5
    static let footerColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
}
