//
//  User.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 21/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import SwiftyJSON

class User {
    var cognitoToken: String!
    var id: String!
    var identityId: String!
    var email: String!
    
    init(_ json: JSON) {
        let user = json["user"]
        cognitoToken = user["cognito_token"].stringValue
        id = user["id"].stringValue
        identityId = user["identity_id"].stringValue
        email = user["email"].stringValue
    }
}

