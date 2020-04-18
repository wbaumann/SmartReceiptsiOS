//
//  GraphsViewModel.swift
//  SmartReceipts
//
//  Created Bogdan Evsenev on 04.04.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift

protocol GraphsViewModelProtocol {
    var dataSet: Observable<[GraphsCategoryDataSet]> { get }
    var trip: WBTrip { get }
    func moduleDidLoad()
}

class GraphsViewModel: GraphsViewModelProtocol {
    private var router: GraphsRouterProtocol
    let trip: WBTrip
    
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
    
    init(router: GraphsRouterProtocol, trip: WBTrip) {
        self.router = router
        self.trip = trip
    }

    func moduleDidLoad() {

    }
}

struct GraphsCategoryDataSet {
    let category: WBCategory
    let total: Price
}
