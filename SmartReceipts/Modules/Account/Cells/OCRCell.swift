//
//  OCRCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 09/08/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift

class OCRCell: UITableViewCell {
    private let bag = DisposeBag()
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ocrCountLabel: UILabel!
    @IBOutlet private weak var configureButton: UIButton!
    
    var onConfigureTap: VoidBlock? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = LocalizedString("menu_main_ocr_configuration")
        configureButton.setTitle(LocalizedString("configure_label"), for: .normal)
        configureButton.apply(style: .mainTextOnly)
        configureButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.onConfigureTap?()
            }).disposed(by: bag)
    }
    
    func configureCell(count: Int) -> Self {
        ocrCountLabel.text = String(format: LocalizedString("ocr_configuration_scans_remaining"), count)
        return self
    }
}
