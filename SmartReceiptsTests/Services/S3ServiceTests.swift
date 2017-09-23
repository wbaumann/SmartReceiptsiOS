//
//  S3ServiceTests.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 23/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import XCTest
import RxSwift
import RxBlocking

fileprivate let TIME_OUT: RxTimeInterval = 5

class S3ServiceTests: XCTestCase {
    let downloadURL = URL(string: "https://s3.amazonaws.com/smartreceipts/Drive/icon_drive.png")!
    let service = S3Service()
    let authSerivce = AuthService()
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        _ = try? authSerivce.login(credentials: Credentials("aaa@aaa.aaa", "12345678"))
            .toBlocking(timeout: TIME_OUT)
            .single()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testUploadUnauth() {
        _ = try? authSerivce.logout().toBlocking(timeout: TIME_OUT).single()
        let url = upload()
        XCTAssertNil(url)
    }
    
    func testDownlaodUnauth() {
        _ = try? authSerivce.logout().toBlocking(timeout: TIME_OUT).single()
        let img = download()
        XCTAssertNil(img)
    }
    
    func testUpload() {
        let url = upload()
        XCTAssertNotNil(url)
    }
    
    func testDownload() {
        let img = download()
        XCTAssertNotNil(img)
    }

    func upload() -> URL? {
        let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test_upload.jpg")!
        try? UIImagePNGRepresentation(#imageLiteral(resourceName: "settings"))?.write(to: imageURL)
        return try? service.upload(file: imageURL).toBlocking(timeout: TIME_OUT).single()!
    }
    
    func download() -> UIImage? {
        return try? service.downloadImage(downloadURL, folder: "Drive/")
            .toBlocking(timeout: TIME_OUT)
            .single()!
    }
}
