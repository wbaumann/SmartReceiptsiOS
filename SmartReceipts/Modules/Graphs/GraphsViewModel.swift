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
    var dataSet: Observable<ChartDataSetProtocol> { get }
    var period: Observable<GraphsAssembly.PeriodSelection> { get }
    var routeObserver: AnyObserver<GraphsRouter.Route> { get }
    var trip: WBTrip { get }
    func moduleDidLoad()
}

class GraphsViewModel: GraphsViewModelProtocol {
    private var router: GraphsRouterProtocol
    private let bag = DisposeBag()
    let trip: WBTrip
    
    let dataSetSubject: BehaviorSubject<ChartDataSetProtocol>
    var dataSet: Observable<ChartDataSetProtocol> {
        return dataSetSubject.asObservable()
    }
    
    let periodSubject: BehaviorRelay<GraphsAssembly.PeriodSelection>
    var period: Observable<GraphsAssembly.PeriodSelection> {
        return periodSubject.asObservable()
    }
    
    let routeRelay: PublishSubject<GraphsRouter.Route> = .init()
    var routeObserver: AnyObserver<GraphsRouter.Route> {
        return routeRelay.asObserver()
    }
    
    private var currentModel: GraphsAssembly.ModelSelection = .categories
    
    init(router: GraphsRouterProtocol, trip: WBTrip) {
        self.router = router
        self.trip = trip
        let emptyDataSet = GraphsCategoryDataSet(data: [])
        self.dataSetSubject = .init(value: emptyDataSet)
        self.periodSubject = .init(value: .report)
    }

    func moduleDidLoad() {
        bind()
        switchModel(to: currentModel)
        switchPeriod(to: periodSubject.value)
    }
    
    private func bind() {
        routeRelay.filterCases(cases: .close)
            .subscribe(onNext: { [weak self] _ in self?.router.close() })
            .disposed(by: bag)
        
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
    
    // MARK: - PRIVATE
    
    private func switchPeriod(to selection: GraphsAssembly.PeriodSelection) {
        periodSubject.accept(selection)
        update(period: periodSubject.value, model: currentModel)
    }
    
    private func switchModel(to selection: GraphsAssembly.ModelSelection) {
        currentModel = selection
        update(period: periodSubject.value, model: currentModel)
    }
    
    private func update(period: GraphsAssembly.PeriodSelection, model: GraphsAssembly.ModelSelection) {
        let dataSet: ChartDataSetProtocol
        switch model {
        case .categories: dataSet = categoryDataSet(period: period)
        case .dates: dataSet = daysDataSet(period: period)
        case .paymentMethods: dataSet = paymentMethodDataSet(period: period)
        }
        dataSetSubject.onNext(dataSet)
    }
    
    var datePeriod: DatePeriod {
        switch periodSubject.value {
        case .report: return DatePeriod(from: .distantPast, to: .distantFuture)
        case .weekly: return DatePeriod(from: Date().addingTimeInterval(-.week), to: .now)
        case .daily: return DatePeriod(from: Date().addingTimeInterval(-.day), to: .now)
        case .monthly: return DatePeriod(from: Calendar.current.date(byAdding: .month, value: -1, to: .now)!, to: .now)
        }
    }
    
    private var receiptsInPeriod: [WBReceipt] {
        let receipts = (Database.sharedInstance().allReceipts(for: trip) ?? []) as [WBReceipt]
        return receipts.filter { datePeriod.included(date: $0.date) }
    }
    
    private func categoryDataSet(period: GraphsAssembly.PeriodSelection) -> ChartDataSetProtocol {
        let receipts = ((Database.sharedInstance().allReceipts(for: trip) ?? []) as [WBReceipt])
        let receiptsInPeriod = receipts.filter { datePeriod.included(date: $0.date) }
        let categories = Set(receiptsInPeriod.compactMap { $0.category })
        let data = categories.map { category -> GraphsCategoryDataSet.GraphsCategoryData? in
            let price = PricesCollection(currencyCode: trip.defaultCurrency.code)
            let cReceipts = receiptsInPeriod.filter { $0.category?.code == category.code }
            cReceipts.forEach { price.addPrice($0.price()) }
            return .init(category: category, total: price)
        }.compactMap { $0 }
        return GraphsCategoryDataSet(data: data)
    }
    
    private func paymentMethodDataSet(period: GraphsAssembly.PeriodSelection) -> ChartDataSetProtocol {
        let paymentMethods = Set(receiptsInPeriod.compactMap { $0.paymentMethod })
        let data = paymentMethods.map { method -> GraphsPaymentMethodDataSet.GraphsPaymentMethodData in
            let price = PricesCollection(currencyCode: trip.defaultCurrency.code)
            let pmReceipts = receiptsInPeriod.filter { $0.paymentMethod == method}
            pmReceipts.forEach { price.addPrice($0.price()) }
            return .init(paymentMethod: method, total: price)
        }
        return GraphsPaymentMethodDataSet(data: data)
    }
    
    private func daysDataSet(period: GraphsAssembly.PeriodSelection) -> ChartDataSetProtocol {
        let days = Set(receiptsInPeriod.map { $0.date.dayString() })
        let data = days.map { day -> GraphsDaysDataSet.GraphsDaysData in
            let price = PricesCollection(currencyCode: trip.defaultCurrency.code)
            let dayReceipts = receiptsInPeriod.filter { $0.date.dayString() == day }
            dayReceipts.forEach { price.addPrice($0.price()) }
            return .init(day: day, total: price)
        }
        return GraphsDaysDataSet(data: data)
    }
    
    private var categoryDataSet: ChartDataSetProtocol {
        let receipts = (Database.sharedInstance().allReceipts(for: trip) ?? []) as [WBReceipt]
        let categories = Set(receipts.compactMap { $0.category })
        let data = categories.map { category -> GraphsCategoryDataSet.GraphsCategoryData? in
            let price = PricesCollection(currencyCode: trip.defaultCurrency.code)
            let cReceipts = receipts.filter { $0.category?.code == category.code }
            cReceipts.forEach { price.addPrice($0.price()) }
            return .init(category: category, total: price)
        }.compactMap { $0 }
        return GraphsCategoryDataSet(data: data)
    }
    
    private var paymentMethodDataSet: ChartDataSetProtocol {
        let receipts = (Database.sharedInstance().allReceipts(for: trip) ?? []) as [WBReceipt]
        let paymentMethods = Set(receipts.compactMap { $0.paymentMethod })
        let data = paymentMethods.map { method -> GraphsPaymentMethodDataSet.GraphsPaymentMethodData in
            let price = PricesCollection(currencyCode: trip.defaultCurrency.code)
            let pmReceipts = receipts.filter { $0.paymentMethod == method}
            pmReceipts.forEach { price.addPrice($0.price()) }
            return .init(paymentMethod: method, total: price)
        }
        return GraphsPaymentMethodDataSet(data: data)
    }
    
    private var daysDataSet: ChartDataSetProtocol {
        let receipts = (Database.sharedInstance().allReceipts(for: trip) ?? []) as [WBReceipt]
        let days = Set(receipts.map { $0.date.dayString() })
        let data = days.map { day -> GraphsDaysDataSet.GraphsDaysData in
            let price = PricesCollection(currencyCode: trip.defaultCurrency.code)
            let dayReceipts = receipts.filter { $0.date.dayString() == day }
            dayReceipts.forEach { price.addPrice($0.price()) }
            return .init(day: day, total: price)
        }
        return GraphsDaysDataSet(data: data)
    }
}

extension GraphsViewModel {
    struct DatePeriod {
        let from: Date
        let to: Date
        
        func included(date: Date) -> Bool {
            return date.timeIntervalSince1970 >= from.timeIntervalSince1970
                && date.timeIntervalSince1970 <= to.timeIntervalSince1970
        }
    }
}


