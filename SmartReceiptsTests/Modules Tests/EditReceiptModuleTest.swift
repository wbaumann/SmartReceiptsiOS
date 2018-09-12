//
//  EditReceiptModuleTest.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 02/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import Cuckoo
@testable import SmartReceipts

import Viperit
import RxSwift
import XCTest

class EditReceiptModuleTest: XCTestCase {
    
    var presenter: EditReceiptPresenter!
    var interactor: MockEditReceiptInteractor!
    var router: MockEditReceiptRouter!
    
    var authService = AuthServiceTestable()
    var scansPurchaseTracker = ScansPurchaseTracker.shared
    var tooltipService = TooltipService.shared
    
    var trip: WBTrip?
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        let p = EditReceiptPresenter()
        
        interactor = MockEditReceiptInteractor(authService: authService, scansPurchaseTracker: scansPurchaseTracker, tooltipService: tooltipService).withEnabledSuperclassSpy()
        
        var module = AppModules.editReceipt.build()
        module.injectMock(presenter: p)
        module.injectMock(interactor: interactor)
        module.injectMock(router: MockEditReceiptRouter().withEnabledSuperclassSpy())
        
        presenter = module.presenter as! EditReceiptPresenter
        router = module.router as! MockEditReceiptRouter
        
        configureStubs()
        
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
    
    func configureStubs() {
        stub(router) { mock in
            mock.close().thenDoNothing()
            mock.openSettings().thenDoNothing()
        }
        
        stub(interactor) { mock in
            mock.configureSubscribers().thenDoNothing()
            mock.tooltipText().thenCallRealImplementation()
        }
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func tooltipTextConfigure() -> String {
        return LocalizedString("ocr.informational.tooltip.configure.text")
    }
    
    private func tooltipTextScansCount() -> String {
        let format = LocalizedString("ocr.informational.tooltip.limited.scans.text")
        return String.localizedStringWithFormat(format, scansPurchaseTracker.remainingScans)
    }
    
    func testPresenterToRouter() {
        presenter.viewHasLoaded()
        
        presenter.settingsTap.onNext(())
        presenter.close()
        
        verify(router).openSettings()
        verify(router).close()
    }
    
    func testPresenterToInteractor() {
        stub(interactor) { mock in
            mock.tooltipText().thenReturn("Hello")
        }
        
        presenter.viewHasLoaded()
        let text = presenter.tooltipText()
        XCTAssertEqual(text, "Hello")
        
        verify(interactor).tooltipText()
        verify(interactor).configureSubscribers()
    }
    
    func testTooltipConfigureText() {
        authService.isLoggedInValue = true
        XCTAssertNotEqual(interactor.tooltipText(), tooltipTextConfigure())
        
        authService.isLoggedInValue = false
        XCTAssertEqual(interactor.tooltipText(), tooltipTextConfigure())
        
        tooltipService.markConfigureOCRDismissed()
        XCTAssertNil(interactor.tooltipText())
        XCTAssertNotEqual(interactor.tooltipText(), tooltipTextConfigure())
    }
    
    func testTooltipScansCountText() {
        authService.isLoggedInValue = true
        LocalScansTracker.shared.scansCount = 10
        tooltipService.markBackupReminderDismissed()
        XCTAssertNil(interactor.tooltipText())
        XCTAssertNotEqual(interactor.tooltipText(), tooltipTextScansCount())
        
        LocalScansTracker.shared.scansCount = 4
        XCTAssertNotNil(interactor.tooltipText())
        XCTAssertEqual(interactor.tooltipText(), tooltipTextScansCount())
    }
}
