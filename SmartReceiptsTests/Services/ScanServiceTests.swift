//
//  ScanServiceTests.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 05/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
@testable import Cuckoo
import XCTest
import RxTest
import RxSwift
import RxCocoa
import SwiftyJSON

class ScanServiceTests: XCTestCase {
    let bag = DisposeBag()
    let s3ServiceMock = MockS3Service().spy(on: S3Service())
    let recognitionAPIMock = MockRecognitionAPI().spy(on: RecognitionAPI())
    let pushService = PushNotificationServiceTestable()
    var scanService: ScanService!
    var authService = AuthServiceTestable()
    var scansPurchaseTracker = ScansPurchaseTracker.shared
    
    let notificationVar = BehaviorRelay(value: JSON())
    let mockID = "1"
    var mockURL: URL!
    let mockImage = #imageLiteral(resourceName: "launch_image")
    var receiptDocument: ReceiptDocument!
    
    
    override func setUp() {
        super.setUp()
        receiptDocument = ReceiptDocument.makeDocumentFrom(image: mockImage)
        mockURL = receiptDocument.localURL
        
        LocalScansTracker.shared.scansCount = 10
        scanService = ScanService(s3Service: s3ServiceMock,
                                  recognitionAPI: recognitionAPIMock,
                                  pushService: pushService,
                                  authService: authService,
                                  scansPurchaseTracker: scansPurchaseTracker)
        pushService.notificationObservable = notificationVar.asObservable()
        authService.isLoggedInValue = true
        configureStubs()
    }
    
    func configureStubs() {
        stub(recognitionAPIMock) { mock in
            mock.recognize(url: mockURL, incognito: false).thenReturn(Observable<String>.just(mockID))
            mock.getRecognition(mockID).then({ _ -> Observable<JSON> in
                let json = JSON.loadFrom(filename: "Scan", type: "json")
                return Observable<JSON>.just(json)
            })
        }
        
        stub(s3ServiceMock) { mock in
            mock.upload(file: mockURL).thenReturn(Observable<URL>.just(mockURL))
            mock.upload(image: mockImage).thenReturn(Observable<URL>.just(mockURL))
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testScanSuccess() {
        let emptyScan = Scan(image: mockImage)
        let scan = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        
        verify(s3ServiceMock).upload(file: mockURL)
        verify(recognitionAPIMock).recognize(url: mockURL, incognito: false)
        verify(recognitionAPIMock).getRecognition(mockID)
        
        XCTAssertNotEqual(emptyScan, scan)
    }
    
    func testHasAvailableScans() {
        let emptyScan = Scan(image: mockImage)
        let scan1 = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        LocalScansTracker.shared.scansCount = 0
        let scan2 = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        LocalScansTracker.shared.scansCount = 10
        let scan3 = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        
        XCTAssertNotNil(scan1.merchant)
        XCTAssertNotEqual(emptyScan, scan1)
        XCTAssertNotEqual(scan1, scan2)
        XCTAssertNotEqual(scan2, scan3)
        XCTAssertEqual(scan1, scan3)
    }
    
    func testAutoScansFlag() {
        let emptyScan = Scan(image: mockImage)
        let scan1 = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        WBPreferences.setAutomaticScansEnabled(false)
        let scan2 = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        WBPreferences.setAutomaticScansEnabled(true)
        let scan3 = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        
        XCTAssertNotNil(scan1.merchant)
        XCTAssertNotEqual(emptyScan, scan1)
        XCTAssertNotEqual(scan1, scan2)
        XCTAssertNotEqual(scan2, scan3)
        XCTAssertEqual(scan1, scan3)
    }
    
    func testAuthLogin() {
        let emptyScan = Scan(image: #imageLiteral(resourceName: "launch_image"))
        let scan1 = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        authService.isLoggedInValue = false
        let scan2 = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        authService.isLoggedInValue = true
        let scan3 = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        
        XCTAssertNotNil(scan1.merchant)
        XCTAssertNotEqual(emptyScan, scan1)
        XCTAssertNotEqual(scan1, scan2)
        XCTAssertNotEqual(scan2, scan3)
        XCTAssertEqual(scan1, scan3)
    }
    
    func testStatus() {
        let scheduler = TestScheduler(initialClock: 0)
        let statusObserver = scheduler.createObserver(ScanStatus.self)
        
        let statusCheck = [
            next(0, ScanStatus.uploading),
            next(0, ScanStatus.scanning),
            next(0, ScanStatus.fetching),
            next(0, ScanStatus.completed),
            next(0, ScanStatus.completed)
        ]
        scheduler.start()
        scanService.status.bind(to: statusObserver).disposed(by: bag)
        
        _ = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        authService.isLoggedInValue = false
        _ = try! scanService.scan(document: receiptDocument).toBlocking().first()!
        
        XCTAssertEqual(statusObserver.events, statusCheck)
    }
    
}


