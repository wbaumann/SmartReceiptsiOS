//
//  BackupView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/02/2018.
//Copyright © 2018 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift
import RxCocoa

//MARK: - Public Interface Protocol
protocol BackupViewInterface {
}

//MARK: BackupView Class
final class BackupView: UserInterface {
    @IBOutlet private weak var closeButton: UIBarButtonItem!
    @IBOutlet private weak var importButton: UIButton!
    @IBOutlet private weak var backupButton: UIButton!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRx()
        configureLayers()
    }
    
    private func configureRx() {
        closeButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: bag)
    }
    
    private func configureLayers() {
        let cornerRadius: CGFloat = 5
        
        importButton.layer.cornerRadius = cornerRadius
        backupButton.layer.cornerRadius = cornerRadius
    }
}

//MARK: - Public interface
extension BackupView: BackupViewInterface {
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension BackupView {
    var presenter: BackupPresenter {
        return _presenter as! BackupPresenter
    }
    var displayData: BackupDisplayData {
        return _displayData as! BackupDisplayData
    }
}
