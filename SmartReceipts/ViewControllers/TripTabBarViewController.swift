//
//  TripTabBarViewController.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 16.11.2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture
import SafariServices

class TripTabBarViewController: TabBarViewController {
    private let bag = DisposeBag()
    private var trip: WBTrip?
    private var tooltipPresenter: TooltipPresenter!
    private var titleView: TripTitleView?
    private var fetchedModelAdapter: FetchedModelAdapter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trip = WBPreferences.lastOpenedTrip
        if let trip = self.trip { setupViewControllers(trip: trip) }
        
        fetchedModelAdapter = Database.sharedInstance().createUpdatingAdapterForAllTrips()
        fetchedModelAdapter.rx.didChangeContent
            .subscribe(onNext: { [weak self] _ in
                guard let trip = self?.trip else { return }
                Database.sharedInstance().refreshPriceForTrip(trip)
                self?.trip = trip
                self?.updateTitle(trip: trip)
            }).disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: false)
        if trip == nil { showTrips(animated: false) }
        configureTitle()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case TabBarViewController.Constants.unselectableTag: return
        case Constants.actionTag: showMoreSheet(); return
        default: break
        }
        
        super.tabBar(tabBar, didSelect: item)
    }
    
    func openTab(at index: Int) {
        guard let items = tabBar.items, index < items.count else { return }
        selectedIndex = index
        tabBar(tabBar, didSelect: items[index])
    }
    
    // MARK: Private
    
    private func configureTitle() {
        titleView = TripTitleView.initFromNib()
        navigationItem.titleView = titleView
        let graphsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "graphs_item"), style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem = graphsButton
        titleView?.tintColor = .white
        updateTitle(trip: trip)
        
        graphsButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let trip = self?.trip else { return }
                let graphsView = GraphsAssembly().build(trip: trip)
                self?.present(graphsView, animated: true, completion: nil)
            }).disposed(by: bag)
        
        
        titleView?.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.showTrips(animated: true)
            }).disposed(by: bag)
    }
    
    private func updateTitle(trip: WBTrip?) {
        if let trip = trip {
            let total = "\(LocalizedString("total")): \(trip.formattedPrice()!)"
            titleView?.set(title: trip.name, subtitle: total)
        } else {
            titleView?.set(title: LocalizedString("add"), subtitle: nil)
        }
    }
    
    private func setupViewControllers(trip: WBTrip) {
        let receiptsModule = AppModules.receipts.build()
        let distancesModule = AppModules.tripDistances.build()
        let generateModule = AppModules.generateReport.build()
        
        receiptsModule.presenter.setupView(data: trip)
        distancesModule.presenter.setupView(data: trip)
        generateModule.presenter.setupView(data: trip)
        
        viewControllers = [
            receiptsModule.view.viewController.tabConfigured(image: #imageLiteral(resourceName: "receipts_tab"), selected: #imageLiteral(resourceName: "receipts_tab_selected")),
            distancesModule.view.viewController.tabConfigured(image: #imageLiteral(resourceName: "distances_tab"), selected: #imageLiteral(resourceName: "distances_tab_selected")),
            UIViewController().tabDisabled(),
            generateModule.view.viewController.tabConfigured(image: #imageLiteral(resourceName: "share_tab"), selected: #imageLiteral(resourceName: "share_tab_selected")),
            UIViewController().tabConfigured(image: #imageLiteral(resourceName: "more_tab"), selected: #imageLiteral(resourceName: "more_tab_selected"), tag: Constants.actionTag)
        ]
    }
}

private extension TripTabBarViewController {
    
    private func showTrips(animated: Bool) {
        let module = AppModules.trips.build()
        let nav = UINavigationController(rootViewController: module.view.viewController)
        nav.modalPresentationStyle = animated ? .formSheet : .fullScreen
        present(nav, animated: animated, completion: nil)
        module.interface(TripsModuleInterface.self).tripSelected
            .subscribe(onNext: { [weak self] trip in
                self?.trip = trip
                self?.updateTitle(trip: trip)
                self?.setupViewControllers(trip: trip)
            }).disposed(by: bag)
    }
    
    func showMoreSheet() {
        MainMenuActionSheet(openOn: self).show()
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

extension UIViewController {
    var tripTabBarConroller: TripTabBarViewController? {
        return tabBarController as? TripTabBarViewController
    }
}

extension TripTabBarViewController {
    enum Constants {
        static let actionTag = -2
    }
}
