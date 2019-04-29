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
        
        var module = AppModules.generateReport.build()
        module.injectMock(presenter: MockGenerateReportPresenter().withEnabledSuperclassSpy())
        module.injectMock(interactor: MockGenerateReportInteractor().withEnabledSuperclassSpy())
        module.injectMock(router: MockGenerateReportRouter().withEnabledSuperclassSpy())
        
        presenter = module.presenter as? MockGenerateReportPresenter
        interactor = module.interactor as? MockGenerateReportInteractor
        router = module.router as? MockGenerateReportRouter
        
        configureStubs()
    }
    
    func configureStubs() {
        stub(router) { mock in
            mock.close().thenDoNothing()
            mock.openSettingsOnDisatnce().thenDoNothing()
            mock.openSettingsOnReportLayout().thenDoNothing()
        }
        
        stub(interactor) { mock in
            mock.generateReport(selection: GenerateReportSelection()).thenDoNothing()
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testPresenterToIntractor() {
        presenter.viewHasLoaded()

        presenter.generateReport(selection: .init())
        verify(interactor).trackGeneratorEvents(selection: GenerateReportSelection())
        verify(interactor).generateReport(selection: GenerateReportSelection())
    }
    
    func testPresenterToRouter() {
        presenter.close()
        verify(router).close()
        
        presenter.presentOutputSettings()
        verify(router).openSettingsOnReportLayout()
        
        presenter.presentEnableDistances()
        verify(router).openSettingsOnDisatnce()
    }
}

extension GenerateReportSelection: Equatable, Matchable {
    public typealias MatchedType = GenerateReportSelection
    
    public var matcher: ParameterMatcher<GenerateReportSelection> {
        return ParameterMatcher<GenerateReportSelection>(matchesFunction: { $0 == self })
    }
    
    public static func == (lhs: GenerateReportSelection, rhs: GenerateReportSelection) -> Bool {
        return [lhs.csvFile, lhs.fullPdfReport, lhs.zipStampedJPGs, lhs.zipFiles, lhs.pdfReportWithoutTable] ==
               [rhs.csvFile, rhs.fullPdfReport, rhs.zipStampedJPGs, rhs.zipFiles, rhs.pdfReportWithoutTable]
    }
}
