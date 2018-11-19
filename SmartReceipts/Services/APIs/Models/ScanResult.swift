//
//  Scan.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 19/11/2018.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit

class ScanResult {
    private(set) var recognition: Recognition?
    private(set) var filepath: URL!
    
    init(image: UIImage) {
        recognition = nil
        self.filepath = cache(image: image)
    }
    
    init(recognition: Recognition? = nil, filepath: URL) {
        self.recognition = recognition
        self.filepath = filepath
    }
    
    private func cache(image: UIImage) -> URL {
        let imgData = image.jpegData(compressionQuality: kImageCompression)!
        try? imgData.write(to: ReceiptDocument.imgTempURL)
        return ReceiptDocument.imgTempURL
    }
}

extension ScanResult: Equatable {
    static func ==(lhs: ScanResult, rhs: ScanResult) -> Bool {
        if lhs === rhs { return true }
        return lhs.filepath == rhs.filepath &&
            lhs.recognition?.createdAt == rhs.recognition?.createdAt &&
            lhs.recognition?.id == rhs.recognition?.id &&
            lhs.recognition?.s3path == rhs.recognition?.s3path &&
            lhs.recognition?.status == rhs.recognition?.status &&
            lhs.recognition?.result.amount == rhs.recognition?.result.amount &&
            lhs.recognition?.result.tax == rhs.recognition?.result.tax
    }
}



