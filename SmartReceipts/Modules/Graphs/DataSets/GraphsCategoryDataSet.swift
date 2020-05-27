//
//  GraphsCategoryDataSet.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 05.05.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import Foundation
import Charts

struct GraphsCategoryDataSet: ChartDataSetProtocol {
    let data: [GraphsCategoryData]
    let xLabels: [String]
    let entries: [ChartDataEntry]
    let chartType: ChartType = .pieChart

    var title: String {
        return "Categories"
    }
    
    init(data: [GraphsCategoryData]) {
        self.data = data
        
        var filteredDataSets = data
            .sorted(by: { $0.total.amount.doubleValue > $1.total.amount.doubleValue })
            .filter { $0.total.amount.doubleValue != 0 }
        
        let labels = filteredDataSets.reduce([String]()) { result, dataSet -> [String] in
            return result.adding(dataSet.category.name)
        }
        
        self.entries = filteredDataSets
            .enumerated()
            .map { index, dataSet in
                return PieChartDataEntry(value: dataSet.total.amount.doubleValue, label: labels[index])
            }
        
        self.xLabels = labels
    }
}

extension GraphsCategoryDataSet {
    struct GraphsCategoryData {
        let category: WBCategory
        let total: Price
    }
}
