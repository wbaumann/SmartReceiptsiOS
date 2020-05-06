//
//  BarChartView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 19.04.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import Foundation
import Charts

protocol BarChartDatSetProtocol {
    var xLabels: [String] { get }
    var entries: [BarChartDataEntry] { get }
    var title: String { get }
}

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
    
    func buildChart(dataSet: BarChartDatSetProtocol) {
        xAxis.valueFormatter = IndexAxisValueFormatter(values: dataSet.xLabels)
        xAxis.labelCount = dataSet.xLabels.count
        
        let chartDataSet = BarChartDataSet(entries: dataSet.entries, label: dataSet.title)
        chartDataSet.valueFont = .systemFont(ofSize: 9, weight: .medium)
        chartDataSet.valueFormatter = valueFormatter
        
        chartDataSet.colors = ChartColorTemplates.material()
        data = BarChartData(dataSet: chartDataSet)
    }
    
}

