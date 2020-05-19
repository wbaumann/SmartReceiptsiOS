//
//  DaysDataSet.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 09.05.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import Foundation
import Charts

struct GraphsDaysDataSet: ChartDataSetProtocol {
    let data: [GraphsDaysData]
    let xLabels: [String]
    let entries: [BarChartDataEntry]
    let chartType: ChartType = .lineChart

    var title: String {
        return "Days"
    }
    
    init(data: [GraphsDaysData], maxCount: Int = 1000) {
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
            return result.adding(dataSet.day)
        }
    }
}

extension GraphsDaysDataSet {
    struct GraphsDaysData {
        let day: String
        let total: Price
    }
}

