//
//  TooltipQuestion.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 22.03.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TooltipQuestion: UIView {
    fileprivate var titleLabel: UILabel!
    fileprivate var yesButton: UIButton!
    fileprivate var noButton: UIButton!
    
    private var isAnimating = false
    private var offset = CGPoint.zero
    private var widthFromScreen = false
    private let bag = DisposeBag()
    
    class func showOn(view: UIView, text: String, offset: CGPoint = .zero, screenWidth: Bool = true) -> TooltipQuestion {
        let width = screenWidth ? UIScreen.main.bounds.width : view.bounds.width
        let frame = CGRect(x: offset.x, y: offset.y, width: width, height: Constants.height)
        let tooltip = TooltipQuestion(frame: frame)
        tooltip.autoresizingMask = .flexibleWidth
        tooltip.widthFromScreen = screenWidth
        tooltip.offset = offset
        tooltip.titleLabel.text = text
        
        view.addSubview(tooltip)
        tooltip.updateFrame()
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
        NotificationCenter.default.addObserver(self,
            selector: #selector(didRotateScreen),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    @objc func didRotateScreen() {
        updateFrame()
    }
    
    private func configureView() {
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
        
        titleLabel = UILabel(frame: frames.labelFrame)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = .regular15
        
        yesButton = createButton(title: LocalizedString("yes"))
        noButton = createButton(title: LocalizedString("no"))
        
        addSubview(titleLabel)
        addSubview(yesButton)
        addSubview(noButton)
        
        Observable.merge([rx.yesAction.asObservable(), rx.noAction.asObservable()])
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
    
    private func updateFrame() {
        let frames = calculateFrames()
        let width = widthFromScreen ? UIScreen.main.bounds.width : superview!.bounds.width
        frame = CGRect(x: offset.x, y: offset.y, width: width, height: frames.labelFrame.height)
        titleLabel.frame = frames.labelFrame
        noButton.frame = frames.noFrame
        yesButton.frame = frames.yesFrame
    }
    
    
    private func calculateFrames() -> (labelFrame: CGRect, yesFrame: CGRect, noFrame: CGRect) {
        let margin: CGFloat = UI_MARGIN_8
        
        guard let yesButton = yesButton else { return (.zero, .zero, .zero) }
        
        yesButton.frame.origin = .init(x: bounds.width - margin*2 - yesButton.bounds.width, y: bounds.midY - yesButton.bounds.midY)
        noButton.frame.origin = .init(x: yesButton.frame.origin.x - 12 - noButton.bounds.width, y: yesButton.frame.origin.y)
        
        let textWidth = noButton.frame.origin.x - margin * 2
        let constraintSize = CGSize(width: textWidth, height: .greatestFiniteMagnitude)
        let boundingBox = titleLabel?.text?.boundingRect(
            with: constraintSize,
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.regular15],
            context: nil
        )
        let textHeight = max(boundingBox?.height ?? 0, Constants.height)
        let labelFrame = CGRect(x: margin*3, y: 0, width: textWidth, height: textHeight)
        
        return (labelFrame, yesButton.frame, noButton.frame)
    }
    
    private func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.contentEdgeInsets = .init(top: 10, left: 12, bottom: 10, right: 12)
        button.setTitle(title.uppercased(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.16)
        button.sizeToFit()
        button.frame.size.height = 40
        return button
    }
}

extension Reactive where Base : TooltipQuestion {
    var yesAction: RxCocoa.ControlEvent<Swift.Void> { get { return base.yesButton.rx.tap } }
    var noAction: RxCocoa.ControlEvent<Swift.Void> { get { return base.noButton.rx.tap } }
}

private extension TooltipQuestion {
    enum Constants {
        static let height: CGFloat = 72
    }
}

