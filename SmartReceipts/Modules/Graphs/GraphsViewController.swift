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
    
    @IBOutlet private var barChartView: BarChart!
    @IBOutlet private var lineChartView: LineChart!
    @IBOutlet private var pieChartView: PieChart!
    @IBOutlet private var periodButton: UIButton!
    @IBOutlet private var modelButton: UIButton!
    @IBOutlet private var closeButton: UIBarButtonItem!
    
    private lazy var graphsInfoViewController: GraphsInfoViewController = {
        let infoView = GraphsInfoViewController.create()
        addPullUpController(infoView, initialStickyPointOffset: 400, animated: false, completion: nil)
        return infoView
    }()
    
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
        barChartView.valueFormatter = valueFormatter
        lineChartView.valueFormatter = valueFormatter
        
        setupChartData()
        viewModel.moduleDidLoad()
        title = LocalizedString("report_info_graphs")
        periodButton.layer.cornerRadius = periodButton.bounds.height/2
        modelButton.layer.cornerRadius = modelButton.bounds.height/2
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func bind() {
        viewModel.period.map { $0.title }
            .bind(to: periodButton.rx.titleBinder())
            .disposed(by: bag)
        
        periodButton.rx.tap.map { .period }
            .bind(to: viewModel.routeObserver)
            .disposed(by: bag)
        
        modelButton.rx.tap.map { .model }
            .bind(to: viewModel.routeObserver)
            .disposed(by: bag)
        
        closeButton.rx.tap.map { .close }
            .bind(to: viewModel.routeObserver)
            .disposed(by: bag)
    }
    
    private func setupChartData() {
        viewModel.dataSet
            .subscribe(onNext: { [weak self] dataSet in
                self?.modelButton.set(title: dataSet.title)
                self?.activateChart(dataSet: dataSet)
            }).disposed(by: bag)
    }
    
    private func activateChart(dataSet: ChartDataSetProtocol) {
        lineChartView.isHidden = true
        barChartView.isHidden = true
        pieChartView.isHidden = true
        
        let activeChart: ChartProtocol
        switch dataSet.chartType {
        case .barChart:
            barChartView.isHidden = false
            activeChart = barChartView
        case .lineChart:
            lineChartView.isHidden = false
            activeChart = lineChartView
        case .pieChart:
            pieChartView.isHidden = false
            activeChart = pieChartView
        }
        activeChart.buildChart(dataSet: dataSet)
        
        
        let items: [GraphsInfoDataSource.Item]
        
        items = dataSet.entries.enumerated().map { index, entry -> GraphsInfoDataSource.Item in
            let title = dataSet.xLabels[index]
            let value = entry.y
            let color = activeChart.color(at: index) ?? .violetMain
            return .init(title: title, total: "$ \(value)", color: color)
        }

        graphsInfoViewController.dataSource = GraphsInfoDataSource(items: items)
    }
    
}

extension GraphsAssembly.PeriodSelection {
    var title: String {
        switch self {
        case .daily: return LocalizedString("graphs.period.day")
        case .weekly: return LocalizedString("graphs.period.week")
        case .monthly: return LocalizedString("graphs.period.month")
        case .report: return LocalizedString("report")
        }
    }
}
