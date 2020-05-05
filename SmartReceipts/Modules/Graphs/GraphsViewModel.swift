//
//  GraphsViewModel.swift
//  SmartReceipts
//
//  Created Bogdan Evsenev on 04.04.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol GraphsViewModelProtocol {
    var dataSet: Observable<[GraphsCategoryDataSet]> { get }
    var routeObserver: AnyObserver<GraphsRouter.Route> { get }
    var trip: WBTrip { get }
    func moduleDidLoad()
}

class GraphsViewModel: GraphsViewModelProtocol {
    private var router: GraphsRouterProtocol
    private let bag = DisposeBag()
    let trip: WBTrip
    
    let routeRelay: PublishSubject<GraphsRouter.Route> = .init()
    var routeObserver: AnyObserver<GraphsRouter.Route> {
        return routeRelay.asObserver()
    }
    
    init(router: GraphsRouterProtocol, trip: WBTrip) {
        self.router = router
        self.trip = trip
    }

    func moduleDidLoad() {
        bind()
        switchModel(to: .categories)
        switchPeriod(to: .report)
    }
    
    private func bind() {
        routeRelay
            .filterCases(cases: .period)
            .flatMap { [weak self] _ in self?.router.openPeriod() ?? .never() }
            .subscribe(onNext: { [weak self] in self?.switchPeriod(to: $0) })
            .disposed(by: bag)
        
        routeRelay
            .filterCases(cases: .model)
            .flatMap { [weak self] _ in self?.router.openModel() ?? .never() }
            .subscribe(onNext: { [weak self] in self?.switchModel(to: $0) })
            .disposed(by: bag)
    }
    
    var dataSet: Observable<[GraphsCategoryDataSet]> {
        let receipts = (Database.sharedInstance().allReceipts(for: trip) ?? []) as [WBReceipt]
        let catCodes = Set(receipts.compactMap { $0.category?.code })
        let categories = Database.sharedInstance().listAllCategories().filter { catCodes.contains($0.code) }
        
        let result = categories.map { category -> GraphsCategoryDataSet in
            let price = PricesCollection(currencyCode: trip.defaultCurrency.code)
            let cReceipts = receipts.filter { $0.category?.code == category.code }
            cReceipts.forEach { price.addPrice($0.price()) }
            return .init(category: category, total: price)
        }
        return .just(result)
    }
    
    // MARK: - PRIVATE
    
    private func switchPeriod(to: GraphsAssembly.PeriodSelection) {
        
    }
    
    private func switchModel(to: GraphsAssembly.ModelSelection) {
        
    }
}

struct GraphsCategoryDataSet {
    let category: WBCategory
    let total: Price
}


