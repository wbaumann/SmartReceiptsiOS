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

private let TAP_ZONE: CGFloat = 44

class TooltipView: UIView {
    
    fileprivate weak var tableView: UITableView?
    fileprivate var textButton: UIButton!
    fileprivate var closeButton: UIButton!
    
    private var isAnimating = false
    private let bag = DisposeBag()
    
    static func showOn(view: UIView, text: String) -> TooltipView {
        if let tableView = view as? UITableView {
            return showOn(tableView: tableView, text: text)
        } else {
            let tooltip = showTooltip(view: view, text: text)
            return tooltip
        }
    }
    
    static func showOn(tableView: UITableView, text: String) -> TooltipView {
        let tooltip = showTooltip(view: tableView.superview!, text: text)
        tableView.contentInset = UIEdgeInsets(top: TAP_ZONE, left: 0, bottom: 0, right: 0)
        tooltip.tableView = tableView
        return tooltip
    }
    
    private static func showTooltip(view: UIView, text: String) -> TooltipView {
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: TAP_ZONE)
        let tooltip = TooltipView(frame: frame)
        tooltip.textButton.setTitle(text, for: .normal)
        tooltip.textButton.titleLabel?.sizeToFit()
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
    
    private func close() {
        isAnimating = true
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 0)
            self.tableView?.contentInset = UIEdgeInsets.zero
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    func didRotateScreen() {
        self.frame = CGRect(x: 0, y: 0, width: superview!.bounds.width, height: TAP_ZONE)
        let frames = calculateFrames()
        textButton.frame = frames.textButtonFrame
        closeButton.frame = frames.closeButtonFrame
    }

    private func calculateFrames() -> (textButtonFrame: CGRect, closeButtonFrame: CGRect) {
        let margin: CGFloat = 8
        let closeButtonFrame = CGRect(x: bounds.width - TAP_ZONE - margin, y: 0, width: TAP_ZONE, height: TAP_ZONE)
        let textButtonFrame = CGRect(x: margin * 2, y: 0, width: closeButtonFrame.origin.x - margin * 3, height: TAP_ZONE)
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
