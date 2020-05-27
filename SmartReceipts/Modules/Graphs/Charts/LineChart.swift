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
//        pinchZoomEnabled = false
//        doubleTapToZoomEnabled = false
//        scaleXEnabled = false
//        scaleYEnabled = false
//        highlightPerTapEnabled = false
//        highlightPerDragEnabled = false
//        rightAxis.drawLabelsEnabled = false
//        drawGridBackgroundEnabled = false
//
//        xAxis.labelPosition = .bottom
//        xAxis.labelFont = .semibold11
//        xAxis.drawGridLinesEnabled = false
//        xAxis.drawAxisLineEnabled = false
//
//        leftAxis.enabled = false
//        rightAxis.enabled = false
        
    }
    
    func buildChart(dataSet: ChartDataSetProtocol) {
        xAxis.valueFormatter = IndexAxisValueFormatter(values: dataSet.xLabels)
//        xAxis.labelCount = dataSet.xLabels.count
        
        let chartDataSet = LineChartDataSet(entries: dataSet.entries, label: dataSet.title)
        chartDataSet.valueFont = .systemFont(ofSize: 9, weight: .medium)
        chartDataSet.valueFormatter = valueFormatter
        chartDataSet.lineWidth = 3
//        chartDataSet.draw
        
        chartDataSet.colors = ChartColorTemplates.material()
        data = LineChartData(dataSet: chartDataSet)
    }
}
