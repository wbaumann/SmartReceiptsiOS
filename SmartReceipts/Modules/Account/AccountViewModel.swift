//
//  AccountViewModel.swift
//  SmartReceipts
//
//  Created Bogdan Evsenev on 29/07/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Toaster

protocol AccountViewModelProtocol {
    func moduleDidLoad()
    var dataSet: Observable<AccountDataSet> { get }
    var onRefresh: AnyObserver<Void> { get }
    var onImportSettings: AnyObserver<OrganizationAppSettings> { get }
    var onLoginTap: AnyObserver<Void> { get }
    var onLogoutTap: AnyObserver<Void> { get }
    var onOcrConfigureTap: AnyObserver<Void> { get }
    var isAuthorized: Observable<Bool> { get }
}

class AccountViewModel: AccountViewModelProtocol {
    private var router: AccountRouterProtocol
    private let organizationsService: OrganizationsServiceInterface
    private let authService: AuthServiceInterface
    private let purhcaseService: PurchaseService
    private let modelConverter = OrganizationModelsConverter()
    private let bag = DisposeBag()
    
    private let dataSetSubject = PublishSubject<AccountDataSet>()
    private let refreshSubject = PublishSubject<Void>()
    private let importSettingsSubject = PublishSubject<OrganizationAppSettings>()
    private let loginTapSubject = PublishSubject<Void>()
    private let logoutTapSubject = PublishSubject<Void>()
    private let ocrConfigureTapSubject = PublishSubject<Void>()
    private let isAuthorizedRelay: BehaviorRelay<Bool>
    
    var dataSet: Observable<AccountDataSet> { return dataSetSubject }
    var onRefresh: AnyObserver<Void> { return refreshSubject.asObserver() }
    var onImportSettings: AnyObserver<OrganizationAppSettings> { return importSettingsSubject.asObserver() }
    var onLoginTap: AnyObserver<Void> { return loginTapSubject.asObserver() }
    var onLogoutTap: AnyObserver<Void> { return logoutTapSubject.asObserver() }
    var onOcrConfigureTap: AnyObserver<Void> { return ocrConfigureTapSubject.asObserver() }
    var isAuthorized: Observable<Bool> { return isAuthorizedRelay.asObservable() }
    
    init(router: AccountRouterProtocol,
         organizationsService: OrganizationsServiceInterface,
         authService: AuthServiceInterface,
         purhcaseService: PurchaseService)
    {
        self.organizationsService = organizationsService
        self.authService = authService
        self.purhcaseService = purhcaseService
        self.router = router
        isAuthorizedRelay = .init(value: authService.isLoggedIn)
    }

    func moduleDidLoad() {
        bind()
    }
    
    private func bind() {
        Observable.merge([refreshSubject, .just])
            .flatMap { [weak self] in self?.getAccountInfo() ?? .never() }
            .subscribe(onNext: { [weak self] in
                self?.dataSetSubject.onNext($0)
            }).disposed(by: bag)
        
        importSettingsSubject
            .subscribe(onNext: { appSettings in
                WBPreferences.importModel(settings: appSettings.settings)
                Database.sharedInstance()?.importSettings(models: appSettings.models)
            }).disposed(by: bag)
        
        loginTapSubject
            .flatMap { [weak self] in self?.router.openLogin().asSingle() ?? .never() }
            .subscribe(onNext: { [weak self] in
                self?.isAuthorizedRelay.accept(true)
                self?.refreshSubject.onNext()
            }).disposed(by: bag)
        
        logoutTapSubject
            .flatMap { [weak self] in self?.authService.logout() ?? .never() }
            .subscribe(onNext: { [weak self] in
                self?.isAuthorizedRelay.accept(false)
            }).disposed(by: bag)
        
        ocrConfigureTapSubject
            .subscribe(onNext: { [weak self] in
                self?.router.openOcr()
            }).disposed(by: bag)
    }
    
    private func getAccountInfo() -> Single<AccountDataSet> {
        guard authService.isLoggedIn else {
            isAuthorizedRelay.accept(false)
            return .never()
        }
        
        let user = authService.getUser().asObservable()
        let organizations = organizationsService.getOrganizations().asObservable()
        let subscriptions = purhcaseService.getSubscriptions().asObservable()
        
        return Observable.combineLatest(user, organizations, subscriptions)
            .asSingle()
            .map { AccountDataSet(user: $0, organiztions: $1, subscriptions: $2) }
    }
}


