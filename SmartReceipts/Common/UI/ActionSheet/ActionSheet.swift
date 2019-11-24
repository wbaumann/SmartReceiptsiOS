//
//  ActionSheet.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24/11/2019.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift

class ActionSheet {
    private var sheetViewController: ActionSheetViewController
    
    init(closable: Bool = true) {
        sheetViewController = ActionSheetViewController.create()
        sheetViewController.closable = closable
        sheetViewController.modalPresentationStyle = .custom
        sheetViewController.loadViewIfNeeded()
    }
    
    @discardableResult
    func addAction(title: String, image: UIImage? = nil, style: ActionButton.Style = .normal) -> Observable<Void> {
        return sheetViewController.addAction(title: title, image: image, style: style)
    }
    
    func show() {
        UIApplication.shared.topViewCtonroller?.present(sheetViewController, animated: true, completion: nil)
    }
}

class ActionSheetViewController: UIViewController, Storyboardable {
    private let bag = DisposeBag()
    
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private var separator: UIView!
    @IBOutlet private var closeButton: UIButton!
    
    @IBOutlet private weak var tapGesture: UITapGestureRecognizer!
    
    fileprivate var closable: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.layer.cornerRadius = 24
        backView.layer.shadowRadius = 32
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = .init(width: 0, height: 4)
        backView.layer.shadowOpacity = 0.24
        
        stackView.arrangedSubviews
            .forEach { $0.removeFromSuperview() }
        
        separator.isHidden = !closable
        closeButton.isHidden = !closable
        
        Observable.merge(closeButton.rx.tap.asObservable(), tapGesture.rx.event.map({ _ in }))
            .filter { [weak self] in self?.closable == true }
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stackView.addArrangedSubview(separator)
        stackView.addArrangedSubview(closeButton)
    }
    
    func addAction(title: String, image: UIImage? = nil, style: ActionButton.Style) -> Observable<Void> {
        let button = ActionButton(title: title, image: image, style: style)
        stackView.addArrangedSubview(button)
        
        return button.rx.tap.flatMap { _ -> Observable<Void> in
            return .create { [weak self] observer -> Disposable in
                self?.dismiss(animated: true, completion: { observer.onNext() })
                return Disposables.create()
            }
        }
    }
}

class ActionButton: UIButton {
    convenience init(title: String, image: UIImage? = nil, style: Style) {
        self.init(type: .system)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 58).isActive = true
        
        contentEdgeInsets = .init(top: 0, left: 14, bottom: 0, right: 0)
        titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        contentHorizontalAlignment = .left
        
        setTitleColor(style.color, for: .normal)
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
        
        tintColor = style.color
        sizeToFit()
    }
    
    enum Style {
        case normal, destructive
        
        var color: UIColor {
            switch self {
            case .normal: return .black
            case .destructive: return .red
            }
        }
    }
}
