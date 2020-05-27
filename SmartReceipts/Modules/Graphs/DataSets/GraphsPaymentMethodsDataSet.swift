//
//  GraphsPaymentMethodsDataSet.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06.05.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import Foundation
import Charts

struct GraphsPaymentMethodDataSet: ChartDataSetProtocol {
    let data: [GraphsPaymentMethodData]
    let xLabels: [String]
    let entries: [ChartDataEntry]
    let chartType: ChartType = .barChart
    
    var title: String {
        return "Payment Methods"
    }
    
    init(data: [GraphsPaymentMethodData], maxCount: Int = 5) {
        self.data = data
        
        var filteredDataSets = data
            .sorted(by: { $0.total.amount.doubleValue > $1.total.amount.doubleValue })
            .filter { $0.total.amount.doubleValue != 0 }
    
        if filteredDataSets.count > maxCount {
            filteredDataSets = Array(filteredDataSets[..<maxCount])
        }
        
        self.entries = filteredDataSets
            .enumerated()
            .map { index, dataSet in
                return BarChartDataEntry(x: Double(index), y: dataSet.total.amount.doubleValue)
            }
        
        self.xLabels = filteredDataSets.reduce([String]()) { result, dataSet -> [String] in
            return result.adding(dataSet.paymentMethod.presentedValue())
        }
    }
}

extension GraphsPaymentMethodDataSet {
    struct GraphsPaymentMethodData {
        let paymentMethod: PaymentMethod
        let total: Price
    }
}
