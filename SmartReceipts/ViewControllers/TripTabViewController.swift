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
    var trip: WBTrip!
    
    private let bag = DisposeBag()
    
    required init(trip: WBTrip) {
        super.init(nibName: "TripTabViewController", bundle: nil)
        self.trip = trip
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppTheme.customizeOnViewDidLoad(self)
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.toolbarItems = [space, editButtonItem]
        editButtonItem.image = #imageLiteral(resourceName: "edit-2")
        
        settings.style.buttonBarBackgroundColor = AppTheme.primaryColor
        settings.style.buttonBarItemBackgroundColor = AppTheme.primaryColor
        settings.style.selectedBarBackgroundColor = AppTheme.accentColor
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 14)
        settings.style.selectedBarHeight = 4
        settings.style.buttonBarLeftContentInset = 16
        settings.style.buttonBarRightContentInset = 16
        
        let buttonFont = UIFont.boldSystemFont(ofSize: 12)
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = #colorLiteral(red: 0.9647058824, green: 0.9637350795, blue: 0.9637350795, alpha: 0.5)
            oldCell?.label.font = buttonFont
            
            newCell?.label.textColor = .white
            newCell?.label.font = buttonFont
        }
        super.viewDidLoad()
    }
    
    func updateEditing() {
        let currentViewController = viewControllers[currentIndex]
        currentViewController.setEditing(!currentViewController.isEditing, animated: true)
    }
    
    //MARK: Private 
    private func subscribeToSubUI(_ ui: UserInterface) {
        guard let titledUI = ui as? TitleSubtitleProtocol else { return }
        titledUI.titleSubtitleSubject.subscribe(onNext: { [unowned self] change in
            if let subtitle = change.subtitle {
                self.setTitle(change.title, subtitle: subtitle)
            } else {
                self.navigationItem.titleView = nil
                self.navigationItem.title = change.title
            }
        }).addDisposableTo(bag)
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
        for subUI in views {
            subscribeToSubUI(subUI)
        }

        return views
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        if toIndex == 2 {
            //Empty item for center align Title/Subtitle in Generate Report Module
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        } else {
            let editItem = UIBarButtonItem(image: #imageLiteral(resourceName: "edit-2"), style: .plain, target: self, action: #selector(updateEditing))
            navigationItem.rightBarButtonItem = editItem
        }
    }
}

extension ReceiptsView: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: LocalizedString("trip.tab.receipts.title"))
    }
}

extension TripDistancesView: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: LocalizedString("trip.tab.distances.title"))
    }
}

extension GenerateReportView: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: LocalizedString("trip.tab.reports.title"))
    }
}

typealias TitleSubtitle = (title: String, subtitle: String?)
protocol TitleSubtitleProtocol {
    var titleSubtitleSubject: PublishSubject<TitleSubtitle> { get }
}
