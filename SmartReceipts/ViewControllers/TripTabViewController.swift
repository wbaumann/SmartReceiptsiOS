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
    
    private var titleSubtitleProtocols: [TitleSubtitleProtocol?]!
    private let bag = DisposeBag()
    
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
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 14)
        settings.style.selectedBarHeight = 4
        settings.style.buttonBarLeftContentInset = 16
        settings.style.buttonBarRightContentInset = 16
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        
        let buttonFont = UIFont.boldSystemFont(ofSize: 12)
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = #colorLiteral(red: 0.9647058824, green: 0.9637350795, blue: 0.9637350795, alpha: 0.5)
            oldCell?.label.font = buttonFont
            
            newCell?.label.textColor = .white
            newCell?.label.font = buttonFont
        }
        super.viewDidLoad()
        view.layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateForIndex(currentIndex)
    }
    
    func updateEditing() {
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
    var titleSubtitle: TitleSubtitle { get }
    var contentChangedSubject: PublishSubject<Void>? { get }
}
