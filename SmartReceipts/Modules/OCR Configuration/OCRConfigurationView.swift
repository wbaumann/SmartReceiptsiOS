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
import RxCocoa

//MARK: - Public Interface Protocol
protocol OCRConfigurationViewInterface {
    var buy10ocr: Observable<Void> { get }
    var buy50ocr: Observable<Void> { get }
    
    var OCR10Price: AnyObserver<String> { get }
    var OCR50Price: AnyObserver<String> { get }
}

//MARK: OCRConfigurationView Class
final class OCRConfigurationView: UserInterface {
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var autoScansLabel: UILabel!
    @IBOutlet private weak var saveImagesLabel: UILabel!
    @IBOutlet private weak var availablePurchases: UILabel!
    @IBOutlet private weak var closeButton: UIBarButtonItem!
    @IBOutlet fileprivate weak var scans10button: ScansPurchaseButton!
    @IBOutlet fileprivate weak var scans50button: ScansPurchaseButton!
    
    @IBOutlet fileprivate weak var autoScans: UISwitch!
    @IBOutlet fileprivate weak var allowSaveImages: UISwitch!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizeLabels()
    
        scans10button.setScans(count: 10)
        scans50button.setScans(count: 50)
        
        autoScans.isOn = WBPreferences.automaticScansEnabled()
        allowSaveImages.isOn = WBPreferences.allowSaveImageForAccuracy()
        
        configureRx()
    }
    
    private func configureRx() {
        ScansPurchaseTracker.shared.fetchAndPersistAvailableRecognitions()
            .map { String(format: LocalizedString("ocr_configuration_scans_remaining"), "\($0)") }
            .subscribe(onNext: { [weak self] in
                self?.setTitle($0, subtitle: AuthService.shared.email)
            }).disposed(by: bag)
        
        autoScans.rx.isOn
            .subscribe(onNext:{ WBPreferences.setAutomaticScansEnabled($0) })
            .disposed(by: bag)
        
        allowSaveImages.rx.isOn
            .subscribe(onNext:{ WBPreferences.setAllowSaveImageForAccuracy($0) })
            .disposed(by: bag)
        
        closeButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: bag)
    }
    
    private func localizeLabels() {
        titleLabel.text = LocalizedString("ocr_configuration_welcome")
        descriptionLabel.text = LocalizedString("ocr.configuration.module.description")
        availablePurchases.text = LocalizedString("ocr_configuration_available_purchases")
        autoScansLabel.text = LocalizedString("ocr_is_enabled")
        saveImagesLabel.text = LocalizedString("ocr_save_scans_to_improve_results")
    }
}

//MARK: - Public interface
extension OCRConfigurationView: OCRConfigurationViewInterface {
    var buy10ocr: Observable<Void> { return scans10button.rx.tap.asObservable() }
    var buy50ocr: Observable<Void> { return scans50button.rx.tap.asObservable() }
    
    var OCR10Price: AnyObserver<String> { return scans10button.rx.price }
    var OCR50Price: AnyObserver<String> { return scans50button.rx.price }
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
