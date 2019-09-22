//
//  OrgranizationsService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24/07/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import RxSwift
import RxCocoa
import Alamofire
import Moya

private let SYNC_ID = "sync.id"

protocol OrganizationsServiceInterface {
    func getOrganizations() -> Single<[OrganizationModel]>
    func saveOrganization(_ organization: OrganizationModel) -> Single<OrganizationModel>
    func sync(organization: OrganizationModel)
    func startSync()
    var currentOrganiztionId: String? { get }
}

class OrganizationsService: OrganizationsServiceInterface {
    private let api: APIProvider<SmartReceiptsAPI>
    private let bag = DisposeBag()
    
    init(api: APIProvider<SmartReceiptsAPI> = .init()) {
        self.api = api
    }
    
    func getOrganizations() -> Single<[OrganizationModel]> {
        return api.request(.organizations)
            .mapModel(OrganizationsResponse.self)
            .map { $0.organizations }
    }
    
    var currentOrganiztionId: String? {
        return UserDefaults.standard.string(forKey: SYNC_ID)
    }
    
    func saveOrganization(_ organization: OrganizationModel) -> Single<OrganizationModel> {
        return api.request(.saveOrganization(organization))
            .mapModel(OrganizationModel.self)
    }
    
    func sync(organization: OrganizationModel) {
        UserDefaults.standard.set(organization.id, forKey: SYNC_ID)
        
        WBPreferences.importModel(settings: organization.appSettings.settings)
        Database.sharedInstance()?.importSettings(models: organization.appSettings.models)
    }
    
    func startSync() {
        AuthService.shared.loggedInObservable
            .filter { $0 }
            .flatMap { _ -> Observable<(String, [OrganizationModel])> in
                let organizationService = ServiceFactory.shared.organizationService
                let idObservable = Observable.just(organizationService.currentOrganiztionId).filterNil().asObservable()
                let organizationsObservable = organizationService.getOrganizations().asObservable()
                return Observable.zip(idObservable, organizationsObservable)
            }.map { id, organizations in
                return organizations.first(where: { $0.id == id })
            }.filterNil()
            .subscribe(onNext: {
                ServiceFactory.shared.organizationService.sync(organization: $0)
            }).disposed(by: bag)
    }
}
