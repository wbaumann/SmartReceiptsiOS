//
//  TripTabBarViewController.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 16.11.2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift

class TripTabBarViewController: TabBarViewController {
    private var titleSubtitleProtocols: [TitleSubtitleProtocol?]!
    private let bag = DisposeBag()
    private var trip: WBTrip!
    private var tooltipPresenter: TooltipPresenter!
    
    static func create(trip: WBTrip) -> TripTabBarViewController {
        let result = Self.create()
        result.trip = trip
        return result
    }
    
    override func viewDidLoad() {
        setupViewControllers()
        super.viewDidLoad()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case Constants.unselectableTag: return
        case Constants.actionTag: showMore(); return
        default: break
        }
        
        super.tabBar(tabBar, didSelect: item)
    }
    
    // MARK: Private
    
    private func showMore() {
        print("showMore")
    }
    
    private func setupViewControllers() {
        let receiptsModule = AppModules.receipts.build()
        let distancesModule = AppModules.tripDistances.build()
        let generateModule = AppModules.generateReport.build()
        
        receiptsModule.presenter.setupView(data: trip)
        distancesModule.presenter.setupView(data: trip)
        generateModule.presenter.setupView(data: trip)
        
        viewControllers = [
            receiptsModule.view.tabConfigured(image: #imageLiteral(resourceName: "receipts_tab"), selected: #imageLiteral(resourceName: "receipts_tab_selected")),
            distancesModule.view.tabConfigured(image: #imageLiteral(resourceName: "distances_tab"), selected: #imageLiteral(resourceName: "distances_tab_selected")),
            UIViewController().tabDisabled(),
            generateModule.view.tabConfigured(image: #imageLiteral(resourceName: "share_tab"), selected: #imageLiteral(resourceName: "share_tab_selected")),
            UIViewController().tabConfigured(image: #imageLiteral(resourceName: "more_tab"), selected: #imageLiteral(resourceName: "more_tab_selected"), tag: Constants.actionTag)
        ]
    }
}

private extension UIViewController {
    func tabConfigured(image: UIImage, selected: UIImage? = nil, tag: Int = 0) -> UIViewController {
        tabBarItem = UITabBarItem(title: nil, image: image, tag: tag)
        tabBarItem.imageInsets = .init(top: UI_MARGIN_16, left: 0, bottom: -UI_MARGIN_16, right: 0)
        tabBarItem.selectedImage = selected
        return self
    }
    
    func tabDisabled() -> UIViewController {
        tabBarItem.isEnabled = false
        return self
    }
}

extension TripTabBarViewController {
    enum Constants {
        static let actionTag = -2
    }
}
