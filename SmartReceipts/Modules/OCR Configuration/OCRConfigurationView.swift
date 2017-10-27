//
//  OCRConfigurationView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/10/2017.
//Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift

//MARK: - Public Interface Protocol
protocol OCRConfigurationViewInterface {
    var buy10ocr: Observable<Void> { get }
    var buy50ocr: Observable<Void> { get }
}

//MARK: OCRConfigurationView Class
final class OCRConfigurationView: UserInterface {
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var autoScansLabel: UILabel!
    @IBOutlet private weak var saveImagesLabel: UILabel!
    @IBOutlet private weak var ocr10purchaseLabel: UILabel!
    @IBOutlet private weak var ocr10purchaseDescription: UILabel!
    @IBOutlet private weak var ocr50purchaseLabel: UILabel!
    @IBOutlet private weak var ocr50purchaseDescription: UILabel!
    @IBOutlet private weak var ocr10price: UILabel!
    @IBOutlet private weak var ocr50price: UILabel!
    @IBOutlet fileprivate weak var ocr10button: UIButton!
    @IBOutlet fileprivate weak var ocr50button: UIButton!
    @IBOutlet private weak var availablePurchases: UILabel!
    
    override func viewDidLoad() {
        localizeLabels()
        configureRx()
        let title = "\(LocalizedString("ocr.configuration.module.scans.remaining")) \(LocalScansTracker.shared.scansCount)"
        setTitle(title, subtitle: AuthService.shared.email)
    }
    
    private func configureRx() {
        
    }
    
    private func localizeLabels() {
        titleLabel.text = LocalizedString("ocr.configuration.module.title")
        descriptionLabel.text = LocalizedString("ocr.configuration.module.description")
        availablePurchases.text = LocalizedString("ocr.configuration.module.avilable.purchases.label")
        autoScansLabel.text = LocalizedString("ocr.configuration.module.automatic.scans.label")
        saveImagesLabel.text = LocalizedString("ocr.configuration.module.save.images.label")
        ocr10purchaseLabel.text = LocalizedString("ocr.configuration.module.10.title")
        ocr10purchaseDescription.text = LocalizedString("ocr.configuration.module.10.description")
        ocr50purchaseLabel.text = LocalizedString("ocr.configuration.module.50.title")
        ocr50purchaseDescription.text = LocalizedString("ocr.configuration.module.50.description")
    }
}

//MARK: - Public interface
extension OCRConfigurationView: OCRConfigurationViewInterface {
    var buy10ocr: Observable<Void> { return ocr10button.rx.tap.asObservable() }
    var buy50ocr: Observable<Void> { return ocr50button.rx.tap.asObservable() }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension OCRConfigurationView {
    var presenter: OCRConfigurationPresenter {
        return _presenter as! OCRConfigurationPresenter
    }
    var displayData: OCRConfigurationDisplayData {
        return _displayData as! OCRConfigurationDisplayData
    }
}
