//
//  PieChart.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 21.05.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import Foundation
import Charts

class PieChart: PieChartView, ChartProtocol {

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    private func configure() {
        legend.enabled = false
    }
    
    func buildChart(dataSet: ChartDataSetProtocol) {
        let chartDataSet = PieChartDataSet(entries: dataSet.entries, label: nil)
        chartDataSet.valueFont = .systemFont(ofSize: 9, weight: .medium)
        chartDataSet.sliceSpace = 2
        chartDataSet.valueLinePart1Length = 0.2
        chartDataSet.yValuePosition = .outsideSlice
        chartDataSet.colors = ChartColorTemplates.vordiplom()
        let pieData = PieChartData(dataSet: chartDataSet)
        pieData.setValueFont(.systemFont(ofSize: 12, weight: .medium))
        pieData.setValueTextColor(.black)
        data = pieData
        
    }
}
