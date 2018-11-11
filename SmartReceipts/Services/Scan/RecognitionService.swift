//
//  RecognitionService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/11/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import RxSwift
import SwiftyJSON
import Moya

class RecognitionService {
    private let apiProvider: APIProvider<SmartReceiptsAPI>
    
    init(apiProvider: APIProvider<SmartReceiptsAPI> = .init()) {
        self.apiProvider = apiProvider
    }

    func getRecognition(_ id: String) -> Single<JSON> {
        return apiProvider.rx.request(.recognition(id: id))
            .map({ JSON($0.data) })
    }
    
    func recognize(url: URL, incognito: Bool = false) -> Single<String> {
        return apiProvider.rx.request(.recognize(url: url, incognito: incognito))
            .mapString(atKeyPath: "recognition.id")
    }
}
