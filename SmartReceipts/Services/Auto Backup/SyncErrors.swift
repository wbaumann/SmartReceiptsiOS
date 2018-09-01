//
//  CriticalSyncError.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 30/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import SwiftyJSON

fileprivate let NO_REMOTE_DISK_SPACE_REASON = "storageQuotaExceeded"
fileprivate let USER_REVOKED_REMOTE_RIGHTS_REASON = "invalid_grant"
fileprivate let AUTH_LOGIN_REQUIRED_REASON = "required"
fileprivate let USER_DELETED_REMOTE_DATA_REASON = "notFound"


enum SyncError: Error {
    case noRemoteDiskSpace
    case userRevokedRemoteRights
    case userDeletedRemoteData
    case unknownError
    
    static func error(_ error: Error) -> SyncError {
        let nsError = error as NSError
        var errorReason = ""
        if let jsonData = nsError.userInfo["data"] as? Data, let json = try? JSON(data: jsonData),
            let reason = json["error"]["errors"].array?.first?["reason"].string {
            errorReason = reason
        } else if let reason = nsError.userInfo["error"] as? String {
            errorReason = reason
        }
        
        switch errorReason {
        case NO_REMOTE_DISK_SPACE_REASON:
            return .noRemoteDiskSpace
        case USER_REVOKED_REMOTE_RIGHTS_REASON, AUTH_LOGIN_REQUIRED_REASON:
            return .userRevokedRemoteRights
        case USER_DELETED_REMOTE_DATA_REASON:
            return .userDeletedRemoteData
        default:
            return .unknownError
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .noRemoteDiskSpace:
            return LocalizedString("drive_sync_error_no_space")
        case .userRevokedRemoteRights:
            return LocalizedString("drive_sync_error_no_permissions")
        case .userDeletedRemoteData:
            return LocalizedString("drive_sync_error_lost_data")
        case .unknownError:
            return LocalizedString("drive_sync_error_unknown")
        }
    }
}
