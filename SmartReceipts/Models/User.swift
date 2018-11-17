//
//  User.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 21/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

struct User: Codable {
    private(set) var recognitionsAvailable: Int
    private(set) var provider: String?
    private(set) var id: String
    private(set) var displayName: String?
    private(set) var cognitoTokenExpiresAt: Date
    private(set) var cognitoToken: String
    private(set) var registrationIds: [String]
    private(set) var email: String
    private(set) var name: String?
    private(set) var confirmedAt: Date?
    private(set) var identityId: String
    private(set) var createdAt: String
    private(set) var confirmationSentAt: Date
    
    enum CodingKeys: String, CodingKey {
        case recognitionsAvailable = "recognitions_available"
        case provider
        case id
        case displayName = "display_name"
        case cognitoTokenExpiresAt = "cognito_token_expires_at_iso8601"
        case cognitoToken = "cognito_token"
        case registrationIds = "registration_ids"
        case email
        case name
        case confirmedAt = "confirmed_at_iso8601"
        case identityId = "identity_id"
        case createdAt = "created_at_iso8601"
        case confirmationSentAt = "confirmation_sent_at_iso8601"
    }
}
