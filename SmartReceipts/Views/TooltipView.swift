//
//  TooltipView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 27/08/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TooltipView: UIView {
    
    static let HEIGHT: CGFloat = 44
    
    fileprivate weak var scrollView: UIScrollView?
    fileprivate var textButton: UIButton!
    fileprivate var closeButton: UIButton!
    
    private var isAnimating = false
    private var offset = CGPoint.zero
    private var widthFromScreen = false
    private let bag = DisposeBag()
    
    static func showOn(view: UIView, text: String, offset: CGPoint = CGPoint.zero, screenWidth: Bool = false) -> TooltipView {
        let width = screenWidth ? UIScreen.main.bounds.width : view.bounds.width
        let frame = CGRect(x: offset.x, y: offset.y, width: width, height: HEIGHT)
        let tooltip = TooltipView(frame: frame)
        tooltip.widthFromScreen = screenWidth
        tooltip.offset = offset
        tooltip.textButton.setTitle(text, for: .normal)
        view.addSubview(tooltip)
        return tooltip
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
        configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        configureView()
    }
    
    private func commonInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(didRotateScreen), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    private func configureView() {
        let font = UIFont.boldSystemFont(ofSize: 13)
        let frames = calculateFrames()
        
        textButton = UIButton(frame: frames.textButtonFrame)
        textButton.titleLabel?.adjustsFontSizeToFitWidth = true
        textButton.contentHorizontalAlignment = .left
        textButton.titleLabel?.font = font
        
        closeButton = UIButton(frame: frames.closeButtonFrame)
        closeButton.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        closeButton.titleLabel?.font = font
        
        addSubview(textButton)
        addSubview(closeButton)
        backgroundColor = AppTheme.accentColor
        
        rx.close.subscribe(onNext: { [unowned self] in
            self.close()
        }).disposed(by: bag)
        
        rx.tap.subscribe(onNext: { [unowned self] in
            self.close()
        }).disposed(by: bag)
    }
    
    func close() {
        isAnimating = true
        UIView.animate(withDuration: DEFAULT_ANIMATION_DURATION, animations: {
            self.alpha = 0
            self.frame = CGRect(x: self.offset.x, y: self.offset.y, width: self.bounds.width, height: 0)
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    func updateFrame() {
        let width = widthFromScreen ? UIScreen.main.bounds.width : superview!.bounds.width
        self.frame = CGRect(x: self.offset.x, y: self.offset.y, width: width, height: TooltipView.HEIGHT)
        let frames = calculateFrames()
        textButton.frame = frames.textButtonFrame
        closeButton.frame = frames.closeButtonFrame
    }
    
    func didRotateScreen() {
        updateFrame()
    }

    private func calculateFrames() -> (textButtonFrame: CGRect, closeButtonFrame: CGRect) {
        let margin: CGFloat = 8
        let closeButtonFrame = CGRect(x: bounds.width - TooltipView.HEIGHT - margin, y: 0,
                                  width: TooltipView.HEIGHT, height: TooltipView.HEIGHT)
        let textButtonFrame = CGRect(x: margin * 2, y: 0, width: closeButtonFrame.origin.x - margin * 3, height: TooltipView.HEIGHT)
        return (textButtonFrame, closeButtonFrame)
    }
}

extension Reactive where Base : TooltipView {
    var tap: RxCocoa.ControlEvent<Swift.Void> { get { return base.textButton.rx.tap } }
    var close: RxCocoa.ControlEvent<Swift.Void> { get { return base.closeButton.rx.tap } }
}

protocol TooltipApplicable {
    func viewForTooltip() -> UIView
}
