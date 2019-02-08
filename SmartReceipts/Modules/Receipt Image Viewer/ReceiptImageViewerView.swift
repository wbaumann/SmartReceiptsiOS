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
        
        let shareItem = UIBarButtonItem(image: #imageLiteral(resourceName: "share-2"), style: .plain, target: self, action: #selector(share))
        
        navigationItem.title = displayData.receipt.name
        navigationItem.rightBarButtonItem = shareItem
        
        imageView = UIImageView(frame: scrollView.bounds)
        scrollView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        
        AppTheme.customizeOnViewDidLoad(self)
        
        configureRx()
    }
    
    private func configureRx() {
        presenter.image.asObservable().bind(to: imageView.rx.image).disposed(by: bag)
        
        let observables = [rotateLeftButton.rx.tap.map { UIImage.Orientation.left },
                           rotateRightButton.rx.tap.map { UIImage.Orientation.right }]
        
        Observable<UIImage.Orientation>.merge(observables)
            .subscribe(onNext: { [unowned self] orientation in
                guard let img = self.presenter.image.value else { return }
                self.presenter.image.accept(WBImageUtils.image(img, with: orientation))
            }).disposed(by: bag)
        
        cameraButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                _ = ImagePicker.shared.presentPicker(on: self).asObservable().bind(to: self.presenter.image)
            }).disposed(by: bag)
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
    
    @objc private func share() {
        guard let image = imageView.image else { return }
        let sharePanel = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        if let popoverController = sharePanel.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        present(sharePanel, animated: true, completion: nil)
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
