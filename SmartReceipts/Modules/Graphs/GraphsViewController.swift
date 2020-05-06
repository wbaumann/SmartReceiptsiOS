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
    
    @IBOutlet private var chartView: BarChart!
    @IBOutlet private var periodButton: UIButton!
    @IBOutlet private var modelButton: UIButton!
    
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
        chartView.valueFormatter = valueFormatter
        setupChartData()
        viewModel.moduleDidLoad()
        title = LocalizedString("report_info_graphs")
        periodButton.layer.cornerRadius = periodButton.bounds.height/2
        modelButton.layer.cornerRadius = modelButton.bounds.height/2
        bind()
    }
    
    private func bind() {
        periodButton.rx.tap.map { .period }
            .bind(to: viewModel.routeObserver)
            .disposed(by: bag)
        
        modelButton.rx.tap.map { .model }
            .bind(to: viewModel.routeObserver)
            .disposed(by: bag)
    }
    
    private func setupChartData() {
        viewModel.dataSet
            .subscribe(onNext: { [weak self] dataSet in
                self?.chartView.buildChart(dataSet: dataSet)
            }).disposed(by: bag)
    }
    
    
}
