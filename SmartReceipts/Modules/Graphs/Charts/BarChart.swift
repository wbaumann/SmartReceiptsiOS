//
//  BarChartView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 19.04.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import Foundation
import Charts

class BarChart: BarChartView {
    var valueFormatter: IValueFormatter?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    private func configure() {
        drawBarShadowEnabled = false
        drawValueAboveBarEnabled = false
        pinchZoomEnabled = false
        doubleTapToZoomEnabled = false
        scaleXEnabled = false
        scaleYEnabled = false
        highlightFullBarEnabled = false
        highlightPerTapEnabled = false
        highlightPerDragEnabled = false
        rightAxis.drawLabelsEnabled = false
        drawGridBackgroundEnabled = false
        drawValueAboveBarEnabled = true
        
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .semibold11
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        
        leftAxis.enabled = false
        rightAxis.enabled = false
    }
    
    func buildChart(dataSets: [GraphsCategoryDataSet]) {
        let filteredDataSets = dataSets
            .sorted(by: { $0.total.amount.doubleValue > $1.total.amount.doubleValue })
            .filter { $0.total.amount.doubleValue != 0 }
        
        let firstFive = filteredDataSets[..<5]
        
        let entries = firstFive
            .enumerated()
            .map { index, dataSet in
                return BarChartDataEntry(x: Double(index), y: dataSet.total.amount.doubleValue)
            }
        
        let xLables = firstFive.reduce([String]()) { result, dataSet -> [String] in
            return result.adding(dataSet.category.name)
        }
        xAxis.valueFormatter = IndexAxisValueFormatter(values: xLables)
        xAxis.labelCount = xLables.count
        
        let chartDataSet = BarChartDataSet(entries: entries, label: "Categories")
        chartDataSet.valueFont = .systemFont(ofSize: 9, weight: .medium)
        chartDataSet.valueFormatter = valueFormatter
        
        chartDataSet.colors = ChartColorTemplates.material()
        data = BarChartData(dataSet: chartDataSet)
    }
    
}

