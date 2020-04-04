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

let TOOLTIP_INSETS = UIEdgeInsets(top: TooltipView.HEIGHT, left: 0, bottom: 0, right: 0)

class TooltipView: UIView {
    
    static let HEIGHT: CGFloat = 72
    
    fileprivate var textButton: UIButton!
    fileprivate var closeButton: UIButton!
    
    private var image = UIImageView(image: nil)
    private var isAnimating = false
    private var offset = CGPoint.zero
    private var widthFromScreen = false
    private let bag = DisposeBag()
    
    class func showOn(view: UIView, text: String, image: UIImage? = nil, offset: CGPoint = .zero, screenWidth: Bool = true) -> TooltipView {
        let width = screenWidth ? UIScreen.main.bounds.width : view.bounds.width
        let frame = CGRect(x: offset.x, y: offset.y, width: width, height: HEIGHT)
        let tooltip = TooltipView(frame: frame)
        tooltip.autoresizingMask = .flexibleWidth
        tooltip.image.image = image
        tooltip.image.contentMode = .center
        tooltip.image.tintColor = .white
        tooltip.widthFromScreen = screenWidth
        tooltip.offset = offset
        tooltip.textButton.setTitle(text, for: .normal)
        
        view.addSubview(tooltip)
        tooltip.updateFrame()
        return tooltip
    }
    
    static func showErrorOn(view: UIView, text: String, image: UIImage? = nil, offset: CGPoint = .zero, screenWidth: Bool = true) -> TooltipView {
        let tooltip = showOn(view: view, text: text, image: image, offset: offset, screenWidth: screenWidth)
        tooltip.backgroundColor = AppTheme.errorColor
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
        NotificationCenter.default.addObserver(self, selector: #selector(didRotateScreen), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    private func configureView() {
        let font = UIFont.boldSystemFont(ofSize: 13)
        let frames = calculateFrames()
        backgroundColor = .clear
    
        let containerView = UIView(frame: bounds)
        containerView.frame.origin.y = UI_MARGIN_8
        containerView.frame.origin.x = UI_MARGIN_8
        containerView.frame.size.height -= UI_MARGIN_16
        containerView.frame.size.width -= UI_MARGIN_16
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.backgroundColor = #colorLiteral(red: 0.368627451, green: 0.3647058824, blue: 0.3882352941, alpha: 1)
        containerView.layer.cornerRadius = 12
        
        addSubview(containerView)
        
        textButton = UIButton(frame: frames.textButtonFrame)
        textButton.titleLabel?.adjustsFontSizeToFitWidth = true
        textButton.contentHorizontalAlignment = .left
        textButton.titleLabel?.font = font
        textButton.titleLabel?.lineBreakMode = .byWordWrapping
        
        closeButton = UIButton(frame: frames.closeButtonFrame)
        closeButton.setImage(#imageLiteral(resourceName: "close_circle"), for: .normal)
        closeButton.titleLabel?.font = font
        
        addSubview(textButton)
        addSubview(closeButton)
        addSubview(image)
        
        Observable.merge([rx.close.asObservable(), rx.action.asObservable()])
            .subscribe(onNext: { [unowned self] in
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
        let frames = calculateFrames()
        let width = widthFromScreen ? UIScreen.main.bounds.width : superview!.bounds.width
        frame = CGRect(x: offset.x, y: offset.y, width: width, height: frames.textButtonFrame.height)
        textButton.frame = frames.textButtonFrame
        closeButton.frame = frames.closeButtonFrame
        image.frame = frames.imageFrame
    }
    
    @objc func didRotateScreen() {
        updateFrame()
    }

    private func calculateFrames() -> (textButtonFrame: CGRect, closeButtonFrame: CGRect, imageFrame: CGRect) {
        let margin: CGFloat = 8
        let width: CGFloat = image.image == nil ? 0 : TooltipView.HEIGHT - margin*2
        let closeButtonFrame = CGRect(x: bounds.width - TooltipView.HEIGHT - margin, y: 0, width: TooltipView.HEIGHT, height: TooltipView.HEIGHT)
        let imageFrame = CGRect(x: margin * 2, y: margin, width: width, height: TooltipView.HEIGHT - margin*2)
        
        let textWidth = closeButtonFrame.origin.x - imageFrame.maxX + margin
        let constraintSize = CGSize(width: textWidth, height: .greatestFiniteMagnitude)
        let boundingBox = textButton?.titleLabel?.text?.boundingRect(
            with: constraintSize,
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.regular15],
            context: nil
        )
        let textHeight = max((boundingBox?.height ?? 0) + UI_MARGIN_16, TooltipView.HEIGHT)

        let textButtonFrame = CGRect(x: imageFrame.maxX + margin, y: 0, width: textWidth, height: textHeight)
        return (textButtonFrame, closeButtonFrame,imageFrame)
    }
}

extension Reactive where Base : TooltipView {
    var action: RxCocoa.ControlEvent<Swift.Void> { get { return base.textButton.rx.tap } }
    var close: RxCocoa.ControlEvent<Swift.Void> { get { return base.closeButton.rx.tap } }
}

protocol TooltipApplicable {
    func viewForTooltip() -> UIView
}
