//
//  TripTabViewController.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/08/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import Viperit

class TripTabViewController: ButtonBarPagerTabStripViewController {
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
    private var titleSubtitleProtocols: [TitleSubtitleProtocol?]!
    private let bag = DisposeBag()
    private var trip: WBTrip!
    private var tooltipPresenter: TooltipPresenter!
    
    required init(trip: WBTrip) {
        super.init(nibName: "TripTabViewController", bundle: nil)
        self.trip = trip
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        AppTheme.customizeOnViewDidLoad(self)
        
        settings.style.buttonBarBackgroundColor = AppTheme.primaryColor
        settings.style.buttonBarItemBackgroundColor = AppTheme.primaryColor
        settings.style.selectedBarBackgroundColor = AppTheme.accentColor
        settings.style.buttonBarItemFont = .systemFont(ofSize: 14)
        settings.style.selectedBarHeight = 4
        settings.style.buttonBarLeftContentInset = 16
        settings.style.buttonBarRightContentInset = 16
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        let buttonFont = UIFont.boldSystemFont(ofSize: 12)
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = #colorLiteral(red: 0.9647058824, green: 0.9637350795, blue: 0.9637350795, alpha: 0.5)
            oldCell?.label.font = buttonFont
            
            newCell?.label.textColor = .white
            newCell?.label.font = buttonFont
        }
        
        tooltipPresenter = TooltipPresenter(view: containerView.superview!, trip: trip)
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateForIndex(currentIndex)
        
        tooltipPresenter.updateInsets.subscribe(onNext: { [weak self] insets in
            self?.applyInsetsForTooltip(insets)
        }).disposed(by: bag)
        
        tooltipPresenter.errorTap.subscribe(onNext: { [weak self] error in
            if error == .userRevokedRemoteRights {
                self?.showBackupsScreen()
            } else if error == .userDeletedRemoteData {
                _ = BackupProvidersManager.shared.clearCurrentBackupConfiguration()
                    .subscribe(onCompleted: {
                        SyncService.shared.trySyncData()
                    })
            } else if error == .noRemoteDiskSpace {
                BackupProvidersManager.shared.markErrorResolved(syncErrorType: .noRemoteDiskSpace)
            }
        }).disposed(by: bag)
        
        tooltipPresenter.generateTap.subscribe(onNext: { [weak self] in
            self?.moveToViewController(at: 2)
        }).disposed(by: bag)
        
        tooltipPresenter.reminderTap.do(onNext: {
            AnalyticsManager.sharedManager.record(event: Event.clickedBackupReminderTip())
        }).subscribe(onNext: { [weak self] in
            self?.showBackupsScreen()
        }).disposed(by: bag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tooltipPresenter.presentBackupReminderIfNeeded()
        tooltipPresenter.presentGenerateIfNeeded()
    }
    
    @objc func updateEditing() {
        let currentViewController = viewControllers[currentIndex]
        currentViewController.setEditing(!currentViewController.isEditing, animated: true)
    }
    
    //MARK: Pager Tab DataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let receiptsModule = AppModules.receipts.build()
        let distancesModule = AppModules.tripDistances.build()
        let generateModule = AppModules.generateReport.build()
        
        receiptsModule.presenter.setupView(data: trip)
        distancesModule.presenter.setupView(data: trip)
        generateModule.presenter.setupView(data: trip)
        
        let views = [receiptsModule.view, distancesModule.view, generateModule.view]
        titleSubtitleProtocols = [receiptsModule.presenter as? TitleSubtitleProtocol,
                                 distancesModule.presenter as? TitleSubtitleProtocol,
                                  generateModule.presenter as? TitleSubtitleProtocol]
        
        for tsp in titleSubtitleProtocols {
            tsp?.contentChangedSubject?.subscribe(onNext: { [unowned self] in
                self.updateForIndex(self.currentIndex)
                self.tooltipPresenter.presentGenerateIfNeeded()
            }).disposed(by: bag)
        }
        
        return views
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        if toIndex == 2 {
            //Empty item for center align Title/Subtitle in Generate Report Module
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        } else {
            let editItem = UIBarButtonItem(image: #imageLiteral(resourceName: "edit-2"), style: .plain, target: self, action: #selector(updateEditing))
            navigationItem.rightBarButtonItem = editItem
        }
        
        if 0..<viewControllers.count ~= toIndex && progressPercentage == 1.0 {
            updateForIndex(toIndex)
            tooltipPresenter.presentGenerateIfNeeded()
        }
    }
    
    //MARK: Private
    
    private func updateForIndex(_ index: Int) {
        update(titleSubtitle: titleSubtitleProtocols[index]?.titleSubtitle ?? ("", nil))
    }
    
    private func update(titleSubtitle: TitleSubtitle) {
        if let subtitle = titleSubtitle.subtitle {
            setTitle(titleSubtitle.title, subtitle: subtitle)
        } else {
            navigationItem.titleView = nil
            navigationItem.title = titleSubtitle.title
        }
    }
    
    private func applyInsetsForTooltip(_ inset: UIEdgeInsets) {
        for vc in viewControllers {
            vc.loadViewIfNeeded()
            (vc as? InsetContent)?.apply(inset: inset)
        }
    }
    
    private func showBackupsScreen() {
        let backupModuleView = AppModules.backup.build().view
        let navController = UINavigationController(rootViewController: backupModuleView)
        navController.modalTransitionStyle = .coverVertical
        navController.modalPresentationStyle = .formSheet
        present(navController, animated: true, completion: nil)
    }
}

extension FetchedTableViewController: InsetContent {
    func apply(inset: UIEdgeInsets) {
        tableView.contentInset = inset
    }
}

protocol InsetContent {
    func apply(inset: UIEdgeInsets)
}

extension ReceiptsView: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: LocalizedString("report_info_receipts"))
    }
}

extension TripDistancesView: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: LocalizedString("report_info_distance"))
    }
}

extension GenerateReportView: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: LocalizedString("report_info_generate"))
    }
}

typealias TitleSubtitle = (title: String, subtitle: String?)
protocol TitleSubtitleProtocol {
    var titleSubtitle: TitleSubtitle { get }
    var contentChangedSubject: PublishSubject<Void>? { get }
}

