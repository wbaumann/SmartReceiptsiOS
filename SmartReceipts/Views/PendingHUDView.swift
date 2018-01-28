//
//  PendingHUDView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 04/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import MRProgress
import RxSwift

class PendingHUDView: MRProgressOverlayView {
    fileprivate let bag = DisposeBag()
    private var imageView: UIImageView?
    
    class func show(on view: UIView, text: String = "", icon: UIImage? = nil) -> PendingHUDView {
        let hud = PendingHUDView()
        hud.titleLabelText = text
        if let hudImage = icon {
            hud.addImageView(icon: hudImage)
            hud.layoutImage(for: view)
        }
        
        if !isRunningTests {
            view.addSubview(hud)
        }
        hud.show(true)
        hud.tintColor = AppTheme.primaryColor
        return hud
    }
    
    class func showFullScreen(text: String = "", icon: UIImage? = nil) -> PendingHUDView {
        let view = UIApplication.shared.keyWindow!
        return PendingHUDView.show(on: view, text: text, icon: icon)
    }
    
    override var titleLabelText: String! {
        get { return super.titleLabelText }
        set {
            layoutImage()
            super.titleLabelText = newValue
        }
    }
    
    func setIcon(_ icon: UIImage?) {
        if imageView == nil {
            addImageView(icon: icon)
        } else {
            imageView?.image = icon
        }
        layoutImage()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutImage()
    }
    
    private func layoutImage(for view: UIView? = nil) {
        if let layoutView = view ?? imageView?.superview {
        let y = layoutView.bounds.height/2 + titleLabel.bounds.height/2
            imageView?.center = CGPoint(x: layoutView.bounds.width/2, y: y)
        }
    }
    
    private func addImageView(icon: UIImage?) {
        imageView = UIImageView(image: icon)
        imageView?.tintColor = AppTheme.primaryColor
        imageView?.contentMode = .scaleAspectFill
        titleLabel.superview?.addSubview(imageView!)
    }
    
    func hide() {
        dismiss(true)
    }
}

// Status Observer
extension PendingHUDView {
    func observe(status: Observable<ScanStatus>) {
        status.subscribe(onNext: { [unowned self] status in
            self.titleLabelText = status.localizedText
            self.setIcon(status.icon)
        }).disposed(by: bag)
    }
}

//MARK: Service info
fileprivate var isRunningTests: Bool {
    #if DEBUG
        let environment = ProcessInfo.processInfo.environment
        let injectBundle = environment["XCInjectBundle"]
        return (injectBundle as NSString?)?.pathExtension == "xctest"
    #else
        return false
    #endif
}
