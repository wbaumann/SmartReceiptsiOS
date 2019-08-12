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

protocol OrganizationsServiceInterface {
    func getOrganizations() -> Single<[OrganizationModel]>
    func saveOrganization(_ organization: OrganizationModel) -> Single<OrganizationModel>
}

class OrganizationsService: OrganizationsServiceInterface {
    private let api: APIProvider<SmartReceiptsAPI>
    
    init(api: APIProvider<SmartReceiptsAPI> = .init()) {
        self.api = api
    }
    
    func getOrganizations() -> Single<[OrganizationModel]> {
        return api.request(.organizations)
            .mapModel(OrganizationsResponse.self)
            .map { $0.organizations }
    }
    
    func saveOrganization(_ organization: OrganizationModel) -> Single<OrganizationModel> {
        return api.request(.saveOrganization(organization))
            .mapModel(OrganizationModel.self)
    }
}
