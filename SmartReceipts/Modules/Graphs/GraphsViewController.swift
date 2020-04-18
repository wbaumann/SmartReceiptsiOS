//
//  GraphsViewController.swift
//  SmartReceipts
//
//  Created Bogdan Evsenev on 04.04.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift
import Charts

class GraphsViewController: UIViewController, Storyboardable {
    var viewModel: GraphsViewModelProtocol!
    private let bag = DisposeBag()
    
    @IBOutlet private var chartView: BarChartView!
    
    private lazy var valueFormatter: IValueFormatter = {
        let locale = Locale.current as NSLocale
        let symbol = locale.displayName(forKey: .currencySymbol, value: viewModel.trip.defaultCurrency.code) ?? ""
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.negativeSuffix = " \(symbol)"
        numberFormatter.positiveSuffix = numberFormatter.negativeSuffix
        return DefaultValueFormatter(formatter: numberFormatter)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureChart()
        setupChartData()
        viewModel.moduleDidLoad()
        title = LocalizedString("report_info_graphs")
    }
    
    private func configureChart() {
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        chartView.highlightFullBarEnabled = false
        chartView.highlightPerTapEnabled = false
        chartView.highlightPerDragEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.drawValueAboveBarEnabled = true
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .semibold11
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
    }
    
    private func setupChartData() {
        viewModel.dataSet
            .subscribe(onNext: { [weak self] dataSets in
                self?.buildChart(dataSets: dataSets)
            }).disposed(by: bag)
    }
    
    private func buildChart(dataSets: [GraphsCategoryDataSet]) {
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
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xLables)
        chartView.xAxis.labelCount = xLables.count
        
        let chartDataSet = BarChartDataSet(entries: entries, label: "Categories")
        chartDataSet.valueFont = .systemFont(ofSize: 9, weight: .medium)
        chartDataSet.valueFormatter = valueFormatter
        
        chartDataSet.colors = ChartColorTemplates.material()
        chartView.data = BarChartData(dataSet: chartDataSet)
    }
}
