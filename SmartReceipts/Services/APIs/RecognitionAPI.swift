//
//  RecognitionAPI.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 05/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift
import SwiftyJSON

fileprivate let RECOGNITION_KEY = "recognition"

class RecognitionAPI {
    func getRecognition(_ id: String) -> Observable<JSON> {
        return APIAdapter.json(.get, endpoint("recognitions/\(id)"))
            .map({ JSON($0) })
    }
    
    func recognize(url: URL, incognito: Bool = false) -> Observable<String> {
        let params = [RECOGNITION_KEY: [
            "s3_path" : "ocr/\(url.lastPathComponent)",
            "incognito" : incognito ] ]
        
        return APIAdapter.jsonBody(.post, endpoint("recognitions"), parameters: params)
            .map({ JSON($0).dictionaryValue[RECOGNITION_KEY]!["id"].string })
            .filter({ $0 != nil })
            .map({ $0! })
    }
}
