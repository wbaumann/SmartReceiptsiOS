//
//  ReceiptImageViewerView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 23/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift
import RxCocoa

//MARK: - Public Interface Protocol
protocol ReceiptImageViewerViewInterface {
    func setup(receipt: WBReceipt)
}

//MARK: ReceiptImageViewerView Class
final class ReceiptImageViewerView: UserInterface {
    
    let bag = DisposeBag()
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var rotateLeftButton: UIBarButtonItem!
    @IBOutlet private weak var cameraButton: UIBarButtonItem!
    @IBOutlet private weak var rotateRightButton: UIBarButtonItem!
    fileprivate var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = displayData.receipt.name
        
        imageView = UIImageView(frame: self.scrollView.bounds)
        scrollView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        
        presenter.image.asObservable().bind(to: imageView.rx.image).disposed(by: bag)
        
        rotateLeftButton.rx.tap.subscribe(onNext: { [unowned self] in
            if let img = self.presenter.image.value {
                self.presenter.image.value = WBImageUtils.image(img, with: .left)
            }
        }).disposed(by: bag)
        
        cameraButton.rx.tap.subscribe(onNext: { [unowned self] in
            _ = ImagePicker.sharedInstance().rx_openOn(self)
                .filter({ $0 != nil })
                .bind(to: self.presenter.image)
        }).disposed(by: bag)
        
        rotateRightButton.rx.tap.subscribe(onNext: { [unowned self] in
            if let img = self.presenter.image.value {
                self.presenter.image.value = WBImageUtils.image(img, with: .right)
            }
        }).disposed(by: bag)
        
        AppTheme.customizeOnViewDidLoad(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        refreshSizes()
    }
    
    private func refreshSizes() {
        imageView.frame = scrollView.bounds
        scrollView.contentSize = scrollView.bounds.size
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
}

//MARK: - UIScrollView Delegate
extension ReceiptImageViewerView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

//MARK: - Public interface
extension ReceiptImageViewerView: ReceiptImageViewerViewInterface {
    func setup(receipt: WBReceipt) {
        displayData.receipt = receipt
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptImageViewerView {
    var presenter: ReceiptImageViewerPresenter {
        return _presenter as! ReceiptImageViewerPresenter
    }
    var displayData: ReceiptImageViewerDisplayData {
        return _displayData as! ReceiptImageViewerDisplayData
    }
}
