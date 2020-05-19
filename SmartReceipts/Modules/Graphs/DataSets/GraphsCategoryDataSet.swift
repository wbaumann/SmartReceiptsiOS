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
    let entries: [BarChartDataEntry]
    let chartType: ChartType = .barChart

    var title: String {
        return "Categories"
    }
    
    init(data: [GraphsCategoryData], maxCount: Int = 5) {
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
            return result.adding(dataSet.category.name)
        }
    }
}

extension GraphsCategoryDataSet {
    struct GraphsCategoryData {
        let category: WBCategory
        let total: Price
    }
}
