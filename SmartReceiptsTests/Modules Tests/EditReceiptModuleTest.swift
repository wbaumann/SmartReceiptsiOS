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
    let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        let p = EditReceiptPresenter()
        let r = EditReceiptRouter()
        let i = EditReceiptInteractor(authService: authService,
                                      scansPurchaseTracker: scansPurchaseTracker,
                                      tooltipService: tooltipService)
        
        var module = AppModules.editReceipt.build()
        module.injectMock(presenter: p)
        module.injectMock(interactor: MockEditReceiptInteractor().spy(on: i))
        module.injectMock(router: MockEditReceiptRouter().spy(on: r))
        
        presenter = module.presenter as! EditReceiptPresenter
        interactor = module.interactor as! MockEditReceiptInteractor
        router = module.router as! MockEditReceiptRouter
        
        // Connect Mock & Real
        p._router = router
        p._interactor = interactor
        i._presenter = presenter
        r._presenter = presenter
        
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
        
        presenter.settingsTap.onNext()
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
        XCTAssertNil(interactor.tooltipText())
        XCTAssertNotEqual(interactor.tooltipText(), tooltipTextScansCount())
        
        LocalScansTracker.shared.scansCount = 4
        XCTAssertNotNil(interactor.tooltipText())
        XCTAssertEqual(interactor.tooltipText(), tooltipTextScansCount())
    }
}
