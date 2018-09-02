//
//  CustomErrors.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 02/09/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

enum DiskError: Error {
    case writingError
    case createFolderError
    case createFileError
}
