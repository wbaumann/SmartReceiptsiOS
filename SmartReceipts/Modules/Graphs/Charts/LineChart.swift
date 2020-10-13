//
//  LineChart.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 13.05.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import Foundation
import Charts

class LineChart: LineChartView, ChartProtocol {
    var valueFormatter: IValueFormatter?

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    private func configure() {
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.drawLimitLinesBehindDataEnabled = false
        
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawLabelsEnabled = false
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawLabelsEnabled = false
        
        xAxis.labelPosition = .bottom
        
    }
    
    func color(at index: Int) -> UIColor? {
        data?.dataSets.first?.color(atIndex: index)
    }
    
    func buildChart(dataSet: ChartDataSetProtocol) {
        xAxis.valueFormatter = IndexAxisValueFormatter(values: dataSet.xLabels)
        
        let chartDataSet = LineChartDataSet(entries: dataSet.entries, label: dataSet.title)
        chartDataSet.valueFont = .systemFont(ofSize: 9, weight: .medium)
        chartDataSet.valueFormatter = valueFormatter
        chartDataSet.lineWidth = 3
        
        chartDataSet.colors = ChartColorTemplates.material()
        data = LineChartData(dataSet: chartDataSet)
        
        
    }
}
