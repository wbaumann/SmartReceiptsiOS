//
//  AuthView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift
import RxCocoa
import Toaster

fileprivate let MINIMUM_EMAIL_LENGTH = 6
fileprivate let MINIMUM_PASSWORD_LENGTH = 8
fileprivate let BUTTON_CORNER_RADIUS: CGFloat = 5

fileprivate typealias ValidationResult = (text: String, valid: Bool)

//MARK: - Public Interface Protocol
protocol AuthViewInterface {
    var login: Observable<Credentials> { get }
    var signup: Observable<Credentials> { get }
    var errorHandler: AnyObserver<String> { get }
    var successLoginHandler: AnyObserver<Void> { get }
    var successSignupHandler: AnyObserver<Void> { get }
    var successLogoutHandler: AnyObserver<Void> { get }
    var logoutTap: Observable<Void> { get }
}

//MARK: AuthView Class
final class AuthView: UserInterface {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var hintLabel: UILabel!
    
    
    var hud: PendingHUDView?
    let loginSubject = PublishSubject<Credentials>()
    let signupSubject = PublishSubject<Credentials>()
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRx()
        emailField.becomeFirstResponder()
        loginButton.layer.cornerRadius = BUTTON_CORNER_RADIUS
        signupButton.layer.cornerRadius = BUTTON_CORNER_RADIUS
    }
    
    private func configureRx() {
        AuthService.shared.loggedInObservable
            .subscribe(onNext: { [unowned self] loggedIn in
                self.logoutButton.isEnabled = loggedIn
            }).disposed(by: bag)
        
        Observable.combineLatest(emailValidator(), passwordValidator(), resultSelector: {
                isVaildEmail, isValidPassword -> ValidationResult in
            if !isVaildEmail {
                return (LocalizedString("login_fields_hint_email"), false)
            } else if !isValidPassword {
                return (LocalizedString("login_fields_hint_password"), false)
            } else {
                return (LocalizedString("login_fields_hint_valid"), true)
            }
        }).subscribe(onNext: { [unowned self] result in
            self.loginButton.isEnabled = result.valid
            self.signupButton.isEnabled = result.valid
            self.hintLabel.text = result.text
        }).disposed(by: bag)
        
        Observable.of(loginButton.rx.tap, signupButton.rx.tap, logoutButton.rx.tap)
            .merge()
            .subscribe(onNext: { [unowned self] _ in
                self.hud = PendingHUDView.show(on: self.view)
            }).disposed(by: bag)
        
        loginButton.rx.tap
            .map({ [unowned self] in
                return self.credentials()
            }).bind(to: loginSubject)
            .disposed(by: bag)
        
        signupButton.rx.tap
            .map({ [unowned self] in
                return self.credentials()
            }).bind(to: signupSubject)
            .disposed(by: bag)
        
        closeButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: bag)
    }
    
    private func credentials() -> Credentials {
       return Credentials(self.emailField.text!, self.passwordField.text!)
    }
    
    private func emailValidator() -> Observable<Bool> {
        return emailField.rx.text
            .map({ email -> Bool in
                if email != nil && email!.count >= MINIMUM_EMAIL_LENGTH {
                    return email!.contains("@") && email!.contains(".")
                }
                return false
            })
    }
    
    private func passwordValidator() -> Observable<Bool> {
        return passwordField.rx.text
            .map({ password -> Bool in
                return password != nil && password!.count >= MINIMUM_PASSWORD_LENGTH
            })
    }
    
}

//MARK: - Public interface
extension AuthView: AuthViewInterface {
    var login: Observable<Credentials> { return loginSubject.asObservable() }
    var signup: Observable<Credentials> { return signupSubject.asObservable() }
    
    var errorHandler: AnyObserver<String> {
        return AnyObserver<String>(eventHandler: { [weak self] event in
            self?.hud?.hide(true)
            switch event {
            case .next(let errorMessage):
                let alert = UIAlertController(title: LocalizedString("login.error.title"), message: errorMessage, preferredStyle: .alert)
                let action = UIAlertAction(title: LocalizedString("generic.button.title.ok"), style: .cancel, handler: nil)
                alert.addAction(action)
                self?.present(alert, animated: true, completion: nil)
            default: break
            }
        })
    }
    
    var successLoginHandler: AnyObserver<Void> {
        return AnyObserver<Void>(eventHandler: { [weak self] event in
            self?.hud?.hide(true)
            switch event {
            case .next:
                Logger.info("The user has successfully logged into Smart Receipts")
                Toast.show(LocalizedString("login_success_toast"))
            default: break
            }
        })
    }
    
    var successSignupHandler: AnyObserver<Void> {
        return AnyObserver<Void>(eventHandler: { [weak self] event in
            self?.hud?.hide(true)
            switch event {
            case .next:
                Logger.info("The user has successfully signed up for Smart Receipts")
                Toast.show(LocalizedString("sign_up_success_toast"))
            default: break
            }
        })
    }
    
    var successLogoutHandler: AnyObserver<Void> {
        return AnyObserver<Void>(eventHandler: { [weak self] event in
            self?.hud?.hide(true)
            switch event {
            case .next:
                Logger.info("Successfully logged out")
            default: break
            }
        })
    }
    
    var logoutTap: Observable<Void> {
        return logoutButton.rx.tap.asObservable()
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension AuthView {
    var presenter: AuthPresenter {
        return _presenter as! AuthPresenter
    }
    var displayData: AuthDisplayData {
        return _displayData as! AuthDisplayData
    }
}
