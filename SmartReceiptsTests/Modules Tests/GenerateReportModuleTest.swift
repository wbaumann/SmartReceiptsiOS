//
//  GenerateReportModuleTest.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 08/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import Cuckoo
@testable import SmartReceipts

import Viperit
import XCTest

class GenerateReportModuleTest: XCTestCase {
    
    var presenter: MockGenerateReportPresenter!
    var interactor: MockGenerateReportInteractor!
    var router: MockGenerateReportRouter!
    
    override func setUp() {
        super.setUp()
        
        let p = GenerateReportPresenter()
        let i = GenerateReportInteractor()
        let r = GenerateReportRouter()
        
        var module = AppModules.generateReport.build()
        module.injectMock(presenter: MockGenerateReportPresenter().spy(on: p))
        module.injectMock(interactor: MockGenerateReportInteractor().spy(on: i))
        module.injectMock(router: MockGenerateReportRouter().spy(on: r))
        
        presenter = module.presenter as! MockGenerateReportPresenter
        interactor = module.interactor as! MockGenerateReportInteractor
        router = module.router as! MockGenerateReportRouter
        
        // Connect Mock & Real
        p._router = router
        p._interactor = interactor
        i._presenter = presenter
        r._presenter = presenter
        
        configureStubs()
    }
    
    func configureStubs() {
        stub(router) { mock in
            mock.close().thenDoNothing()
            mock.openSettings().thenDoNothing()
        }
        
        stub(interactor) { mock in
            mock.generateReport().thenDoNothing()
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPresenterToIntractor() {
        presenter.viewHasLoaded()
        verify(interactor).configureBinding()
        verify(interactor).trackConfigureReportEvent()
        
        presenter.generateReport()
        verify(interactor).trackGeneratorEvents()
        verify(interactor).generateReport()
    }
    
    func testPresenterToRouter() {
        presenter.close()
        verify(router).close()
        
        presenter.presentSettings()
        verify(router).openSettings()
    }
    
    func testPresenterRxFlags() {
        presenter.viewHasLoaded()
        
        XCTAssertFalse(interactor.validateSelection())
        
        presenter.zipStampedJPGs.onNext(true)
        XCTAssertTrue(interactor.validateSelection())
        
        presenter.fullPdfReport.onNext(true)
        XCTAssertTrue(interactor.validateSelection())
        
        presenter.pdfReportWithoutTable.onNext(true)
        XCTAssertTrue(interactor.validateSelection())
        
        presenter.csvFile.onNext(true)
        XCTAssertTrue(interactor.validateSelection())
        
        presenter.zipStampedJPGs.onNext(false)
        presenter.fullPdfReport.onNext(false)
        presenter.csvFile.onNext(false)
        presenter.pdfReportWithoutTable.onNext(false)
        XCTAssertFalse(interactor.validateSelection())
    }
    
}
