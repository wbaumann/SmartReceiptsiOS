// MARK: - Mocks generated from file: SmartReceipts/Modules/Generate Report/GenerateReportPresenter.swift at 2017-08-18 10:14:34 +0000

//
//  GenerateReportPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit

class MockGenerateReportPresenter: GenerateReportPresenter, Cuckoo.Mock {
    typealias MocksType = GenerateReportPresenter
    typealias Stubbing = __StubbingProxy_GenerateReportPresenter
    typealias Verification = __VerificationProxy_GenerateReportPresenter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: GenerateReportPresenter?

    func spy(on victim: GenerateReportPresenter) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func viewHasLoaded()  {
        
        return cuckoo_manager.call("viewHasLoaded()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.viewHasLoaded()
                }
            })
        
    }
    
     override func setupView(data: Any)  {
        
        return cuckoo_manager.call("setupView(data: Any)",
            parameters: (data),
            original: observed.map { o in
                return { (data: Any) in
                    o.setupView(data: data)
                }
            })
        
    }
    
     override func close()  {
        
        return cuckoo_manager.call("close()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.close()
                }
            })
        
    }
    
     override func generateReport()  {
        
        return cuckoo_manager.call("generateReport()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.generateReport()
                }
            })
        
    }
    
     override func presentAlert(title: String, message: String)  {
        
        return cuckoo_manager.call("presentAlert(title: String, message: String)",
            parameters: (title, message),
            original: observed.map { o in
                return { (title: String, message: String) in
                    o.presentAlert(title: title, message: message)
                }
            })
        
    }
    
     override func presentSheet(title: String?, message: String?, actions: [UIAlertAction])  {
        
        return cuckoo_manager.call("presentSheet(title: String?, message: String?, actions: [UIAlertAction])",
            parameters: (title, message, actions),
            original: observed.map { o in
                return { (title: String?, message: String?, actions: [UIAlertAction]) in
                    o.presentSheet(title: title, message: message, actions: actions)
                }
            })
        
    }
    
     override func present(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)  {
        
        return cuckoo_manager.call("present(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)",
            parameters: (vc, animated, isPopover, completion),
            original: observed.map { o in
                return { (vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?) in
                    o.present(vc: vc, animated: animated, isPopover: isPopover, completion: completion)
                }
            })
        
    }
    
     override func presentSettings()  {
        
        return cuckoo_manager.call("presentSettings()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.presentSettings()
                }
            })
        
    }
    
     override func hideHudFromView()  {
        
        return cuckoo_manager.call("hideHudFromView()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.hideHudFromView()
                }
            })
        
    }
    

    struct __StubbingProxy_GenerateReportPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func viewHasLoaded() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("viewHasLoaded()", parameterMatchers: matchers))
        }
        
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.StubNoReturnFunction<(Any)> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub("setupView(data: Any)", parameterMatchers: matchers))
        }
        
        func close() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("close()", parameterMatchers: matchers))
        }
        
        func generateReport() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("generateReport()", parameterMatchers: matchers))
        }
        
        func presentAlert<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(title: M1, message: M2) -> Cuckoo.StubNoReturnFunction<(String, String)> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub("presentAlert(title: String, message: String)", parameterMatchers: matchers))
        }
        
        func presentSheet<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(title: M1, message: M2, actions: M3) -> Cuckoo.StubNoReturnFunction<(String?, String?, [UIAlertAction])> where M1.MatchedType == String?, M2.MatchedType == String?, M3.MatchedType == [UIAlertAction] {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String?, [UIAlertAction])>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }, wrap(matchable: actions) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub("presentSheet(title: String?, message: String?, actions: [UIAlertAction])", parameterMatchers: matchers))
        }
        
        func present<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(vc: M1, animated: M2, isPopover: M3, completion: M4) -> Cuckoo.StubNoReturnFunction<(UIViewController, Bool, Bool, (() -> Void)?)> where M1.MatchedType == UIViewController, M2.MatchedType == Bool, M3.MatchedType == Bool, M4.MatchedType == (() -> Void)? {
            let matchers: [Cuckoo.ParameterMatcher<(UIViewController, Bool, Bool, (() -> Void)?)>] = [wrap(matchable: vc) { $0.0 }, wrap(matchable: animated) { $0.1 }, wrap(matchable: isPopover) { $0.2 }, wrap(matchable: completion) { $0.3 }]
            return .init(stub: cuckoo_manager.createStub("present(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)", parameterMatchers: matchers))
        }
        
        func presentSettings() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("presentSettings()", parameterMatchers: matchers))
        }
        
        func hideHudFromView() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("hideHudFromView()", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_GenerateReportPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func viewHasLoaded() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("viewHasLoaded()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify("setupView(data: Any)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("close()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func generateReport() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("generateReport()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func presentAlert<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(title: M1, message: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }]
            return cuckoo_manager.verify("presentAlert(title: String, message: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func presentSheet<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(title: M1, message: M2, actions: M3) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String?, M2.MatchedType == String?, M3.MatchedType == [UIAlertAction] {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String?, [UIAlertAction])>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }, wrap(matchable: actions) { $0.2 }]
            return cuckoo_manager.verify("presentSheet(title: String?, message: String?, actions: [UIAlertAction])", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func present<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(vc: M1, animated: M2, isPopover: M3, completion: M4) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == UIViewController, M2.MatchedType == Bool, M3.MatchedType == Bool, M4.MatchedType == (() -> Void)? {
            let matchers: [Cuckoo.ParameterMatcher<(UIViewController, Bool, Bool, (() -> Void)?)>] = [wrap(matchable: vc) { $0.0 }, wrap(matchable: animated) { $0.1 }, wrap(matchable: isPopover) { $0.2 }, wrap(matchable: completion) { $0.3 }]
            return cuckoo_manager.verify("present(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func presentSettings() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("presentSettings()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func hideHudFromView() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("hideHudFromView()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class GenerateReportPresenterStub: GenerateReportPresenter {
    

    

    
     override func viewHasLoaded()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func setupView(data: Any)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func close()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func generateReport()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func presentAlert(title: String, message: String)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func presentSheet(title: String?, message: String?, actions: [UIAlertAction])  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func present(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func presentSettings()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func hideHudFromView()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Generate Report/GenerateReportInteractor.swift at 2017-08-18 10:14:34 +0000

//
//  GenerateReportInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxCocoa
import RxSwift
import Viperit

class MockGenerateReportInteractor: GenerateReportInteractor, Cuckoo.Mock {
    typealias MocksType = GenerateReportInteractor
    typealias Stubbing = __StubbingProxy_GenerateReportInteractor
    typealias Verification = __VerificationProxy_GenerateReportInteractor
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: GenerateReportInteractor?

    func spy(on victim: GenerateReportInteractor) -> Self {
        observed = victim
        return self
    }

    
    // ["name": "generator", "accesibility": "", "@type": "InstanceVariable", "type": "ReportAssetsGenerator?", "isReadOnly": false]
     override var generator: ReportAssetsGenerator? {
        get {
            return cuckoo_manager.getter("generator", original: observed.map { o in return { () -> ReportAssetsGenerator? in o.generator }})
        }
        
        set {
            cuckoo_manager.setter("generator", value: newValue, original: observed != nil ? { self.observed?.generator = $0 } : nil)
        }
        
    }
    
    // ["name": "shareService", "accesibility": "", "@type": "InstanceVariable", "type": "GenerateReportShareService?", "isReadOnly": false]
     override var shareService: GenerateReportShareService? {
        get {
            return cuckoo_manager.getter("shareService", original: observed.map { o in return { () -> GenerateReportShareService? in o.shareService }})
        }
        
        set {
            cuckoo_manager.setter("shareService", value: newValue, original: observed != nil ? { self.observed?.shareService = $0 } : nil)
        }
        
    }
    

    

    
     override func configureBinding()  {
        
        return cuckoo_manager.call("configureBinding()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.configureBinding()
                }
            })
        
    }
    
     override func trackConfigureReportEvent()  {
        
        return cuckoo_manager.call("trackConfigureReportEvent()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.trackConfigureReportEvent()
                }
            })
        
    }
    
     override func trackGeneratorEvents()  {
        
        return cuckoo_manager.call("trackGeneratorEvents()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.trackGeneratorEvents()
                }
            })
        
    }
    
     override func generateReport()  {
        
        return cuckoo_manager.call("generateReport()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.generateReport()
                }
            })
        
    }
    
     override func validateSelection()  -> Bool {
        
        return cuckoo_manager.call("validateSelection() -> Bool",
            parameters: (),
            original: observed.map { o in
                return { () -> Bool in
                    o.validateSelection()
                }
            })
        
    }
    

    struct __StubbingProxy_GenerateReportInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var generator: Cuckoo.ToBeStubbedProperty<ReportAssetsGenerator?> {
            return .init(manager: cuckoo_manager, name: "generator")
        }
        
        var shareService: Cuckoo.ToBeStubbedProperty<GenerateReportShareService?> {
            return .init(manager: cuckoo_manager, name: "shareService")
        }
        
        
        func configureBinding() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("configureBinding()", parameterMatchers: matchers))
        }
        
        func trackConfigureReportEvent() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("trackConfigureReportEvent()", parameterMatchers: matchers))
        }
        
        func trackGeneratorEvents() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("trackGeneratorEvents()", parameterMatchers: matchers))
        }
        
        func generateReport() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("generateReport()", parameterMatchers: matchers))
        }
        
        func validateSelection() -> Cuckoo.StubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("validateSelection() -> Bool", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_GenerateReportInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        
        var generator: Cuckoo.VerifyProperty<ReportAssetsGenerator?> {
            return .init(manager: cuckoo_manager, name: "generator", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var shareService: Cuckoo.VerifyProperty<GenerateReportShareService?> {
            return .init(manager: cuckoo_manager, name: "shareService", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        

        
        @discardableResult
        func configureBinding() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("configureBinding()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func trackConfigureReportEvent() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("trackConfigureReportEvent()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func trackGeneratorEvents() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("trackGeneratorEvents()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func generateReport() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("generateReport()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func validateSelection() -> Cuckoo.__DoNotUse<Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("validateSelection() -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class GenerateReportInteractorStub: GenerateReportInteractor {
    
     override var generator: ReportAssetsGenerator? {
        get {
            return DefaultValueRegistry.defaultValue(for: (ReportAssetsGenerator?).self)
        }
        
        set { }
        
    }
    
     override var shareService: GenerateReportShareService? {
        get {
            return DefaultValueRegistry.defaultValue(for: (GenerateReportShareService?).self)
        }
        
        set { }
        
    }
    

    

    
     override func configureBinding()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func trackConfigureReportEvent()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func trackGeneratorEvents()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func generateReport()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func validateSelection()  -> Bool {
        return DefaultValueRegistry.defaultValue(for: Bool.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Categories/CategoriesPresenter.swift at 2017-08-18 10:14:34 +0000

//
//  CategoriesPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit

class MockCategoriesPresenter: CategoriesPresenter, Cuckoo.Mock {
    typealias MocksType = CategoriesPresenter
    typealias Stubbing = __StubbingProxy_CategoriesPresenter
    typealias Verification = __VerificationProxy_CategoriesPresenter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: CategoriesPresenter?

    func spy(on victim: CategoriesPresenter) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func viewHasLoaded()  {
        
        return cuckoo_manager.call("viewHasLoaded()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.viewHasLoaded()
                }
            })
        
    }
    
     override func presentAlert(title: String?, message: String)  {
        
        return cuckoo_manager.call("presentAlert(title: String?, message: String)",
            parameters: (title, message),
            original: observed.map { o in
                return { (title: String?, message: String) in
                    o.presentAlert(title: title, message: message)
                }
            })
        
    }
    
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        
        return cuckoo_manager.call("fetchedModelAdapter() -> FetchedModelAdapter?",
            parameters: (),
            original: observed.map { o in
                return { () -> FetchedModelAdapter? in
                    o.fetchedModelAdapter()
                }
            })
        
    }
    

    struct __StubbingProxy_CategoriesPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func viewHasLoaded() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("viewHasLoaded()", parameterMatchers: matchers))
        }
        
        func presentAlert<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(title: M1, message: M2) -> Cuckoo.StubNoReturnFunction<(String?, String)> where M1.MatchedType == String?, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String)>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub("presentAlert(title: String?, message: String)", parameterMatchers: matchers))
        }
        
        func fetchedModelAdapter() -> Cuckoo.StubFunction<(), Optional<FetchedModelAdapter>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("fetchedModelAdapter() -> FetchedModelAdapter?", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_CategoriesPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func viewHasLoaded() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("viewHasLoaded()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func presentAlert<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(title: M1, message: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String?, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String)>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }]
            return cuckoo_manager.verify("presentAlert(title: String?, message: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func fetchedModelAdapter() -> Cuckoo.__DoNotUse<Optional<FetchedModelAdapter>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("fetchedModelAdapter() -> FetchedModelAdapter?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class CategoriesPresenterStub: CategoriesPresenter {
    

    

    
     override func viewHasLoaded()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func presentAlert(title: String?, message: String)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        return DefaultValueRegistry.defaultValue(for: Optional<FetchedModelAdapter>.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Receipt/EditReceiptRouter.swift at 2017-08-18 10:14:34 +0000

//
//  EditReceiptRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit

class MockEditReceiptRouter: EditReceiptRouter, Cuckoo.Mock {
    typealias MocksType = EditReceiptRouter
    typealias Stubbing = __StubbingProxy_EditReceiptRouter
    typealias Verification = __VerificationProxy_EditReceiptRouter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: EditReceiptRouter?

    func spy(on victim: EditReceiptRouter) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func openSettings()  {
        
        return cuckoo_manager.call("openSettings()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.openSettings()
                }
            })
        
    }
    
     override func close()  {
        
        return cuckoo_manager.call("close()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.close()
                }
            })
        
    }
    

    struct __StubbingProxy_EditReceiptRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func openSettings() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("openSettings()", parameterMatchers: matchers))
        }
        
        func close() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("close()", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_EditReceiptRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func openSettings() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("openSettings()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("close()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class EditReceiptRouterStub: EditReceiptRouter {
    

    

    
     override func openSettings()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func close()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Trips/TripsRouter.swift at 2017-08-18 10:14:34 +0000

//
//  TripsRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit

class MockTripsRouter: TripsRouter, Cuckoo.Mock {
    typealias MocksType = TripsRouter
    typealias Stubbing = __StubbingProxy_TripsRouter
    typealias Verification = __VerificationProxy_TripsRouter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: TripsRouter?

    func spy(on victim: TripsRouter) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func openSettings()  {
        
        return cuckoo_manager.call("openSettings()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.openSettings()
                }
            })
        
    }
    
     override func openEdit(trip: WBTrip)  {
        
        return cuckoo_manager.call("openEdit(trip: WBTrip)",
            parameters: (trip),
            original: observed.map { o in
                return { (trip: WBTrip) in
                    o.openEdit(trip: trip)
                }
            })
        
    }
    
     override func openAddTrip()  {
        
        return cuckoo_manager.call("openAddTrip()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.openAddTrip()
                }
            })
        
    }
    
     override func openDetails(trip: WBTrip)  {
        
        return cuckoo_manager.call("openDetails(trip: WBTrip)",
            parameters: (trip),
            original: observed.map { o in
                return { (trip: WBTrip) in
                    o.openDetails(trip: trip)
                }
            })
        
    }
    
     override func openNoTrips()  {
        
        return cuckoo_manager.call("openNoTrips()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.openNoTrips()
                }
            })
        
    }
    

    struct __StubbingProxy_TripsRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func openSettings() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("openSettings()", parameterMatchers: matchers))
        }
        
        func openEdit<M1: Cuckoo.Matchable>(trip: M1) -> Cuckoo.StubNoReturnFunction<(WBTrip)> where M1.MatchedType == WBTrip {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
            return .init(stub: cuckoo_manager.createStub("openEdit(trip: WBTrip)", parameterMatchers: matchers))
        }
        
        func openAddTrip() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("openAddTrip()", parameterMatchers: matchers))
        }
        
        func openDetails<M1: Cuckoo.Matchable>(trip: M1) -> Cuckoo.StubNoReturnFunction<(WBTrip)> where M1.MatchedType == WBTrip {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
            return .init(stub: cuckoo_manager.createStub("openDetails(trip: WBTrip)", parameterMatchers: matchers))
        }
        
        func openNoTrips() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("openNoTrips()", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_TripsRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func openSettings() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("openSettings()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func openEdit<M1: Cuckoo.Matchable>(trip: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == WBTrip {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
            return cuckoo_manager.verify("openEdit(trip: WBTrip)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func openAddTrip() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("openAddTrip()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func openDetails<M1: Cuckoo.Matchable>(trip: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == WBTrip {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
            return cuckoo_manager.verify("openDetails(trip: WBTrip)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func openNoTrips() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("openNoTrips()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class TripsRouterStub: TripsRouter {
    

    

    
     override func openSettings()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openEdit(trip: WBTrip)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openAddTrip()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openDetails(trip: WBTrip)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openNoTrips()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Trips/TripsPresenter.swift at 2017-08-18 10:14:34 +0000

//
//  TripsPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit

class MockTripsPresenter: TripsPresenter, Cuckoo.Mock {
    typealias MocksType = TripsPresenter
    typealias Stubbing = __StubbingProxy_TripsPresenter
    typealias Verification = __VerificationProxy_TripsPresenter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: TripsPresenter?

    func spy(on victim: TripsPresenter) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func viewHasLoaded()  {
        
        return cuckoo_manager.call("viewHasLoaded()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.viewHasLoaded()
                }
            })
        
    }
    
     override func presentSettings()  {
        
        return cuckoo_manager.call("presentSettings()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.presentSettings()
                }
            })
        
    }
    
     override func presentAddTrip()  {
        
        return cuckoo_manager.call("presentAddTrip()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.presentAddTrip()
                }
            })
        
    }
    
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        
        return cuckoo_manager.call("fetchedModelAdapter() -> FetchedModelAdapter?",
            parameters: (),
            original: observed.map { o in
                return { () -> FetchedModelAdapter? in
                    o.fetchedModelAdapter()
                }
            })
        
    }
    

    struct __StubbingProxy_TripsPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func viewHasLoaded() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("viewHasLoaded()", parameterMatchers: matchers))
        }
        
        func presentSettings() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("presentSettings()", parameterMatchers: matchers))
        }
        
        func presentAddTrip() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("presentAddTrip()", parameterMatchers: matchers))
        }
        
        func fetchedModelAdapter() -> Cuckoo.StubFunction<(), Optional<FetchedModelAdapter>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("fetchedModelAdapter() -> FetchedModelAdapter?", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_TripsPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func viewHasLoaded() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("viewHasLoaded()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func presentSettings() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("presentSettings()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func presentAddTrip() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("presentAddTrip()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func fetchedModelAdapter() -> Cuckoo.__DoNotUse<Optional<FetchedModelAdapter>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("fetchedModelAdapter() -> FetchedModelAdapter?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class TripsPresenterStub: TripsPresenter {
    

    

    
     override func viewHasLoaded()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func presentSettings()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func presentAddTrip()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        return DefaultValueRegistry.defaultValue(for: Optional<FetchedModelAdapter>.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipt Move Copy/ReceiptMoveCopyInteractor.swift at 2017-08-18 10:14:34 +0000

//
//  ReceiptMoveCopyInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 22/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit

class MockReceiptMoveCopyInteractor: ReceiptMoveCopyInteractor, Cuckoo.Mock {
    typealias MocksType = ReceiptMoveCopyInteractor
    typealias Stubbing = __StubbingProxy_ReceiptMoveCopyInteractor
    typealias Verification = __VerificationProxy_ReceiptMoveCopyInteractor
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: ReceiptMoveCopyInteractor?

    func spy(on victim: ReceiptMoveCopyInteractor) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func configureSubscribers()  {
        
        return cuckoo_manager.call("configureSubscribers()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.configureSubscribers()
                }
            })
        
    }
    
     override func fetchedModelAdapter(for receipt: WBReceipt)  -> FetchedModelAdapter {
        
        return cuckoo_manager.call("fetchedModelAdapter(for: WBReceipt) -> FetchedModelAdapter",
            parameters: (receipt),
            original: observed.map { o in
                return { (receipt: WBReceipt) -> FetchedModelAdapter in
                    o.fetchedModelAdapter(for: receipt)
                }
            })
        
    }
    

    struct __StubbingProxy_ReceiptMoveCopyInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func configureSubscribers() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("configureSubscribers()", parameterMatchers: matchers))
        }
        
        func fetchedModelAdapter<M1: Cuckoo.Matchable>(for receipt: M1) -> Cuckoo.StubFunction<(WBReceipt), FetchedModelAdapter> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub("fetchedModelAdapter(for: WBReceipt) -> FetchedModelAdapter", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_ReceiptMoveCopyInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func configureSubscribers() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("configureSubscribers()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func fetchedModelAdapter<M1: Cuckoo.Matchable>(for receipt: M1) -> Cuckoo.__DoNotUse<FetchedModelAdapter> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify("fetchedModelAdapter(for: WBReceipt) -> FetchedModelAdapter", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class ReceiptMoveCopyInteractorStub: ReceiptMoveCopyInteractor {
    

    

    
     override func configureSubscribers()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func fetchedModelAdapter(for receipt: WBReceipt)  -> FetchedModelAdapter {
        return DefaultValueRegistry.defaultValue(for: FetchedModelAdapter.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Generate Report/GenerateReportRouter.swift at 2017-08-18 10:14:34 +0000

//
//  GenerateReportRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit

class MockGenerateReportRouter: GenerateReportRouter, Cuckoo.Mock {
    typealias MocksType = GenerateReportRouter
    typealias Stubbing = __StubbingProxy_GenerateReportRouter
    typealias Verification = __VerificationProxy_GenerateReportRouter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: GenerateReportRouter?

    func spy(on victim: GenerateReportRouter) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func close()  {
        
        return cuckoo_manager.call("close()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.close()
                }
            })
        
    }
    
     override func openSheet(title: String?, message: String?, actions: [UIAlertAction])  {
        
        return cuckoo_manager.call("openSheet(title: String?, message: String?, actions: [UIAlertAction])",
            parameters: (title, message, actions),
            original: observed.map { o in
                return { (title: String?, message: String?, actions: [UIAlertAction]) in
                    o.openSheet(title: title, message: message, actions: actions)
                }
            })
        
    }
    
     override func openSettings()  {
        
        return cuckoo_manager.call("openSettings()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.openSettings()
                }
            })
        
    }
    
     override func open(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)  {
        
        return cuckoo_manager.call("open(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)",
            parameters: (vc, animated, isPopover, completion),
            original: observed.map { o in
                return { (vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?) in
                    o.open(vc: vc, animated: animated, isPopover: isPopover, completion: completion)
                }
            })
        
    }
    

    struct __StubbingProxy_GenerateReportRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func close() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("close()", parameterMatchers: matchers))
        }
        
        func openSheet<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(title: M1, message: M2, actions: M3) -> Cuckoo.StubNoReturnFunction<(String?, String?, [UIAlertAction])> where M1.MatchedType == String?, M2.MatchedType == String?, M3.MatchedType == [UIAlertAction] {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String?, [UIAlertAction])>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }, wrap(matchable: actions) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub("openSheet(title: String?, message: String?, actions: [UIAlertAction])", parameterMatchers: matchers))
        }
        
        func openSettings() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("openSettings()", parameterMatchers: matchers))
        }
        
        func open<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(vc: M1, animated: M2, isPopover: M3, completion: M4) -> Cuckoo.StubNoReturnFunction<(UIViewController, Bool, Bool, (() -> Void)?)> where M1.MatchedType == UIViewController, M2.MatchedType == Bool, M3.MatchedType == Bool, M4.MatchedType == (() -> Void)? {
            let matchers: [Cuckoo.ParameterMatcher<(UIViewController, Bool, Bool, (() -> Void)?)>] = [wrap(matchable: vc) { $0.0 }, wrap(matchable: animated) { $0.1 }, wrap(matchable: isPopover) { $0.2 }, wrap(matchable: completion) { $0.3 }]
            return .init(stub: cuckoo_manager.createStub("open(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_GenerateReportRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("close()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func openSheet<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(title: M1, message: M2, actions: M3) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String?, M2.MatchedType == String?, M3.MatchedType == [UIAlertAction] {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String?, [UIAlertAction])>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }, wrap(matchable: actions) { $0.2 }]
            return cuckoo_manager.verify("openSheet(title: String?, message: String?, actions: [UIAlertAction])", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func openSettings() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("openSettings()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func open<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(vc: M1, animated: M2, isPopover: M3, completion: M4) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == UIViewController, M2.MatchedType == Bool, M3.MatchedType == Bool, M4.MatchedType == (() -> Void)? {
            let matchers: [Cuckoo.ParameterMatcher<(UIViewController, Bool, Bool, (() -> Void)?)>] = [wrap(matchable: vc) { $0.0 }, wrap(matchable: animated) { $0.1 }, wrap(matchable: isPopover) { $0.2 }, wrap(matchable: completion) { $0.3 }]
            return cuckoo_manager.verify("open(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class GenerateReportRouterStub: GenerateReportRouter {
    

    

    
     override func close()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openSheet(title: String?, message: String?, actions: [UIAlertAction])  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openSettings()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func open(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Distance/EditDistanceInteractor.swift at 2017-08-18 10:14:34 +0000

//
//  EditDistanceInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit

class MockEditDistanceInteractor: EditDistanceInteractor, Cuckoo.Mock {
    typealias MocksType = EditDistanceInteractor
    typealias Stubbing = __StubbingProxy_EditDistanceInteractor
    typealias Verification = __VerificationProxy_EditDistanceInteractor
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: EditDistanceInteractor?

    func spy(on victim: EditDistanceInteractor) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func save(distance: Distance, asNewDistance: Bool)  {
        
        return cuckoo_manager.call("save(distance: Distance, asNewDistance: Bool)",
            parameters: (distance, asNewDistance),
            original: observed.map { o in
                return { (distance: Distance, asNewDistance: Bool) in
                    o.save(distance: distance, asNewDistance: asNewDistance)
                }
            })
        
    }
    

    struct __StubbingProxy_EditDistanceInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(distance: M1, asNewDistance: M2) -> Cuckoo.StubNoReturnFunction<(Distance, Bool)> where M1.MatchedType == Distance, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Distance, Bool)>] = [wrap(matchable: distance) { $0.0 }, wrap(matchable: asNewDistance) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub("save(distance: Distance, asNewDistance: Bool)", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_EditDistanceInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(distance: M1, asNewDistance: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Distance, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Distance, Bool)>] = [wrap(matchable: distance) { $0.0 }, wrap(matchable: asNewDistance) { $0.1 }]
            return cuckoo_manager.verify("save(distance: Distance, asNewDistance: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class EditDistanceInteractorStub: EditDistanceInteractor {
    

    

    
     override func save(distance: Distance, asNewDistance: Bool)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipts/ReceiptsPresenter.swift at 2017-08-18 10:14:34 +0000

//
//  ReceiptsPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxCocoa
import RxSwift
import Viperit

class MockReceiptsPresenter: ReceiptsPresenter, Cuckoo.Mock {
    typealias MocksType = ReceiptsPresenter
    typealias Stubbing = __StubbingProxy_ReceiptsPresenter
    typealias Verification = __VerificationProxy_ReceiptsPresenter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: ReceiptsPresenter?

    func spy(on victim: ReceiptsPresenter) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func viewHasLoaded()  {
        
        return cuckoo_manager.call("viewHasLoaded()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.viewHasLoaded()
                }
            })
        
    }
    
     override func setupView(data: Any)  {
        
        return cuckoo_manager.call("setupView(data: Any)",
            parameters: (data),
            original: observed.map { o in
                return { (data: Any) in
                    o.setupView(data: data)
                }
            })
        
    }
    
     override func distanceReceipts()  -> [WBReceipt] {
        
        return cuckoo_manager.call("distanceReceipts() -> [WBReceipt]",
            parameters: (),
            original: observed.map { o in
                return { () -> [WBReceipt] in
                    o.distanceReceipts()
                }
            })
        
    }
    
     override func nextID()  -> String {
        
        return cuckoo_manager.call("nextID() -> String",
            parameters: (),
            original: observed.map { o in
                return { () -> String in
                    o.nextID()
                }
            })
        
    }
    

    struct __StubbingProxy_ReceiptsPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func viewHasLoaded() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("viewHasLoaded()", parameterMatchers: matchers))
        }
        
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.StubNoReturnFunction<(Any)> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub("setupView(data: Any)", parameterMatchers: matchers))
        }
        
        func distanceReceipts() -> Cuckoo.StubFunction<(), [WBReceipt]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("distanceReceipts() -> [WBReceipt]", parameterMatchers: matchers))
        }
        
        func nextID() -> Cuckoo.StubFunction<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("nextID() -> String", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_ReceiptsPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func viewHasLoaded() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("viewHasLoaded()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify("setupView(data: Any)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func distanceReceipts() -> Cuckoo.__DoNotUse<[WBReceipt]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("distanceReceipts() -> [WBReceipt]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func nextID() -> Cuckoo.__DoNotUse<String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("nextID() -> String", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class ReceiptsPresenterStub: ReceiptsPresenter {
    

    

    
     override func viewHasLoaded()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func setupView(data: Any)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func distanceReceipts()  -> [WBReceipt] {
        return DefaultValueRegistry.defaultValue(for: [WBReceipt].self)
    }
    
     override func nextID()  -> String {
        return DefaultValueRegistry.defaultValue(for: String.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Columns/ColumnsPresenter.swift at 2017-08-18 10:14:34 +0000

//
//  ColumnsPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit

class MockColumnsPresenter: ColumnsPresenter, Cuckoo.Mock {
    typealias MocksType = ColumnsPresenter
    typealias Stubbing = __StubbingProxy_ColumnsPresenter
    typealias Verification = __VerificationProxy_ColumnsPresenter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: ColumnsPresenter?

    func spy(on victim: ColumnsPresenter) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func setupView(data: Any)  {
        
        return cuckoo_manager.call("setupView(data: Any)",
            parameters: (data),
            original: observed.map { o in
                return { (data: Any) in
                    o.setupView(data: data)
                }
            })
        
    }
    
     override func viewIsAboutToDisappear()  {
        
        return cuckoo_manager.call("viewIsAboutToDisappear()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.viewIsAboutToDisappear()
                }
            })
        
    }
    

    struct __StubbingProxy_ColumnsPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.StubNoReturnFunction<(Any)> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub("setupView(data: Any)", parameterMatchers: matchers))
        }
        
        func viewIsAboutToDisappear() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("viewIsAboutToDisappear()", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_ColumnsPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify("setupView(data: Any)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func viewIsAboutToDisappear() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("viewIsAboutToDisappear()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class ColumnsPresenterStub: ColumnsPresenter {
    

    

    
     override func setupView(data: Any)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func viewIsAboutToDisappear()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Trip Distances/TripDistancesInteractor.swift at 2017-08-18 10:14:34 +0000

//
//  TripDistancesInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit

class MockTripDistancesInteractor: TripDistancesInteractor, Cuckoo.Mock {
    typealias MocksType = TripDistancesInteractor
    typealias Stubbing = __StubbingProxy_TripDistancesInteractor
    typealias Verification = __VerificationProxy_TripDistancesInteractor
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: TripDistancesInteractor?

    func spy(on victim: TripDistancesInteractor) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func fetchedModelAdapter(for trip: WBTrip)  -> FetchedModelAdapter {
        
        return cuckoo_manager.call("fetchedModelAdapter(for: WBTrip) -> FetchedModelAdapter",
            parameters: (trip),
            original: observed.map { o in
                return { (trip: WBTrip) -> FetchedModelAdapter in
                    o.fetchedModelAdapter(for: trip)
                }
            })
        
    }
    
     override func delete(distance: Distance)  {
        
        return cuckoo_manager.call("delete(distance: Distance)",
            parameters: (distance),
            original: observed.map { o in
                return { (distance: Distance) in
                    o.delete(distance: distance)
                }
            })
        
    }
    

    struct __StubbingProxy_TripDistancesInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func fetchedModelAdapter<M1: Cuckoo.Matchable>(for trip: M1) -> Cuckoo.StubFunction<(WBTrip), FetchedModelAdapter> where M1.MatchedType == WBTrip {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
            return .init(stub: cuckoo_manager.createStub("fetchedModelAdapter(for: WBTrip) -> FetchedModelAdapter", parameterMatchers: matchers))
        }
        
        func delete<M1: Cuckoo.Matchable>(distance: M1) -> Cuckoo.StubNoReturnFunction<(Distance)> where M1.MatchedType == Distance {
            let matchers: [Cuckoo.ParameterMatcher<(Distance)>] = [wrap(matchable: distance) { $0 }]
            return .init(stub: cuckoo_manager.createStub("delete(distance: Distance)", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_TripDistancesInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func fetchedModelAdapter<M1: Cuckoo.Matchable>(for trip: M1) -> Cuckoo.__DoNotUse<FetchedModelAdapter> where M1.MatchedType == WBTrip {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
            return cuckoo_manager.verify("fetchedModelAdapter(for: WBTrip) -> FetchedModelAdapter", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func delete<M1: Cuckoo.Matchable>(distance: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Distance {
            let matchers: [Cuckoo.ParameterMatcher<(Distance)>] = [wrap(matchable: distance) { $0 }]
            return cuckoo_manager.verify("delete(distance: Distance)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class TripDistancesInteractorStub: TripDistancesInteractor {
    

    

    
     override func fetchedModelAdapter(for trip: WBTrip)  -> FetchedModelAdapter {
        return DefaultValueRegistry.defaultValue(for: FetchedModelAdapter.self)
    }
    
     override func delete(distance: Distance)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Trip/EditTripInteractor.swift at 2017-08-18 10:14:34 +0000

//
//  EditTripInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit

class MockEditTripInteractor: EditTripInteractor, Cuckoo.Mock {
    typealias MocksType = EditTripInteractor
    typealias Stubbing = __StubbingProxy_EditTripInteractor
    typealias Verification = __VerificationProxy_EditTripInteractor
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: EditTripInteractor?

    func spy(on victim: EditTripInteractor) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func configureSubscribers()  {
        
        return cuckoo_manager.call("configureSubscribers()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.configureSubscribers()
                }
            })
        
    }
    
     override func save(trip: WBTrip, update: Bool)  {
        
        return cuckoo_manager.call("save(trip: WBTrip, update: Bool)",
            parameters: (trip, update),
            original: observed.map { o in
                return { (trip: WBTrip, update: Bool) in
                    o.save(trip: trip, update: update)
                }
            })
        
    }
    

    struct __StubbingProxy_EditTripInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func configureSubscribers() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("configureSubscribers()", parameterMatchers: matchers))
        }
        
        func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(trip: M1, update: M2) -> Cuckoo.StubNoReturnFunction<(WBTrip, Bool)> where M1.MatchedType == WBTrip, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip, Bool)>] = [wrap(matchable: trip) { $0.0 }, wrap(matchable: update) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub("save(trip: WBTrip, update: Bool)", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_EditTripInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func configureSubscribers() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("configureSubscribers()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(trip: M1, update: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == WBTrip, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip, Bool)>] = [wrap(matchable: trip) { $0.0 }, wrap(matchable: update) { $0.1 }]
            return cuckoo_manager.verify("save(trip: WBTrip, update: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class EditTripInteractorStub: EditTripInteractor {
    

    

    
     override func configureSubscribers()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func save(trip: WBTrip, update: Bool)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipts/ReceiptsRouter.swift at 2017-08-18 10:14:34 +0000

//
//  ReceiptsRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit

class MockReceiptsRouter: ReceiptsRouter, Cuckoo.Mock {
    typealias MocksType = ReceiptsRouter
    typealias Stubbing = __StubbingProxy_ReceiptsRouter
    typealias Verification = __VerificationProxy_ReceiptsRouter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: ReceiptsRouter?

    func spy(on victim: ReceiptsRouter) -> Self {
        observed = victim
        return self
    }

    
    // ["name": "moduleTrip", "accesibility": "", "@type": "InstanceVariable", "type": "WBTrip!", "isReadOnly": false]
     override var moduleTrip: WBTrip! {
        get {
            return cuckoo_manager.getter("moduleTrip", original: observed.map { o in return { () -> WBTrip! in o.moduleTrip }})
        }
        
        set {
            cuckoo_manager.setter("moduleTrip", value: newValue, original: observed != nil ? { self.observed?.moduleTrip = $0 } : nil)
        }
        
    }
    

    

    
     override func openDistances()  {
        
        return cuckoo_manager.call("openDistances()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.openDistances()
                }
            })
        
    }
    
     override func openImageViewer(for receipt: WBReceipt)  {
        
        return cuckoo_manager.call("openImageViewer(for: WBReceipt)",
            parameters: (receipt),
            original: observed.map { o in
                return { (receipt: WBReceipt) in
                    o.openImageViewer(for: receipt)
                }
            })
        
    }
    
     override func openPDFViewer(for receipt: WBReceipt)  {
        
        return cuckoo_manager.call("openPDFViewer(for: WBReceipt)",
            parameters: (receipt),
            original: observed.map { o in
                return { (receipt: WBReceipt) in
                    o.openPDFViewer(for: receipt)
                }
            })
        
    }
    
     override func openGenerateReport()  {
        
        return cuckoo_manager.call("openGenerateReport()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.openGenerateReport()
                }
            })
        
    }
    
     override func openCreateReceipt()  {
        
        return cuckoo_manager.call("openCreateReceipt()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.openCreateReceipt()
                }
            })
        
    }
    
     override func openCreatePhotoReceipt()  {
        
        return cuckoo_manager.call("openCreatePhotoReceipt()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.openCreatePhotoReceipt()
                }
            })
        
    }
    
     override func openActions(receipt: WBReceipt)  -> ReceiptActionsPresenter {
        
        return cuckoo_manager.call("openActions(receipt: WBReceipt) -> ReceiptActionsPresenter",
            parameters: (receipt),
            original: observed.map { o in
                return { (receipt: WBReceipt) -> ReceiptActionsPresenter in
                    o.openActions(receipt: receipt)
                }
            })
        
    }
    
     override func openEdit(receipt: WBReceipt, image: UIImage?)  {
        
        return cuckoo_manager.call("openEdit(receipt: WBReceipt, image: UIImage?)",
            parameters: (receipt, image),
            original: observed.map { o in
                return { (receipt: WBReceipt, image: UIImage?) in
                    o.openEdit(receipt: receipt, image: image)
                }
            })
        
    }
    

    struct __StubbingProxy_ReceiptsRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var moduleTrip: Cuckoo.ToBeStubbedProperty<WBTrip?> {
            return .init(manager: cuckoo_manager, name: "moduleTrip")
        }
        
        
        func openDistances() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("openDistances()", parameterMatchers: matchers))
        }
        
        func openImageViewer<M1: Cuckoo.Matchable>(for receipt: M1) -> Cuckoo.StubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub("openImageViewer(for: WBReceipt)", parameterMatchers: matchers))
        }
        
        func openPDFViewer<M1: Cuckoo.Matchable>(for receipt: M1) -> Cuckoo.StubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub("openPDFViewer(for: WBReceipt)", parameterMatchers: matchers))
        }
        
        func openGenerateReport() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("openGenerateReport()", parameterMatchers: matchers))
        }
        
        func openCreateReceipt() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("openCreateReceipt()", parameterMatchers: matchers))
        }
        
        func openCreatePhotoReceipt() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("openCreatePhotoReceipt()", parameterMatchers: matchers))
        }
        
        func openActions<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.StubFunction<(WBReceipt), ReceiptActionsPresenter> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub("openActions(receipt: WBReceipt) -> ReceiptActionsPresenter", parameterMatchers: matchers))
        }
        
        func openEdit<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(receipt: M1, image: M2) -> Cuckoo.StubNoReturnFunction<(WBReceipt, UIImage?)> where M1.MatchedType == WBReceipt, M2.MatchedType == UIImage? {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt, UIImage?)>] = [wrap(matchable: receipt) { $0.0 }, wrap(matchable: image) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub("openEdit(receipt: WBReceipt, image: UIImage?)", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_ReceiptsRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        
        var moduleTrip: Cuckoo.VerifyProperty<WBTrip?> {
            return .init(manager: cuckoo_manager, name: "moduleTrip", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        

        
        @discardableResult
        func openDistances() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("openDistances()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func openImageViewer<M1: Cuckoo.Matchable>(for receipt: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify("openImageViewer(for: WBReceipt)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func openPDFViewer<M1: Cuckoo.Matchable>(for receipt: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify("openPDFViewer(for: WBReceipt)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func openGenerateReport() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("openGenerateReport()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func openCreateReceipt() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("openCreateReceipt()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func openCreatePhotoReceipt() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("openCreatePhotoReceipt()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func openActions<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.__DoNotUse<ReceiptActionsPresenter> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify("openActions(receipt: WBReceipt) -> ReceiptActionsPresenter", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func openEdit<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(receipt: M1, image: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == WBReceipt, M2.MatchedType == UIImage? {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt, UIImage?)>] = [wrap(matchable: receipt) { $0.0 }, wrap(matchable: image) { $0.1 }]
            return cuckoo_manager.verify("openEdit(receipt: WBReceipt, image: UIImage?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class ReceiptsRouterStub: ReceiptsRouter {
    
     override var moduleTrip: WBTrip! {
        get {
            return DefaultValueRegistry.defaultValue(for: (WBTrip!).self)
        }
        
        set { }
        
    }
    

    

    
     override func openDistances()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openImageViewer(for receipt: WBReceipt)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openPDFViewer(for receipt: WBReceipt)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openGenerateReport()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openCreateReceipt()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openCreatePhotoReceipt()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openActions(receipt: WBReceipt)  -> ReceiptActionsPresenter {
        return DefaultValueRegistry.defaultValue(for: ReceiptActionsPresenter.self)
    }
    
     override func openEdit(receipt: WBReceipt, image: UIImage?)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Trips/TripsInteractor.swift at 2017-08-18 10:14:34 +0000

//
//  TripsInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit

class MockTripsInteractor: TripsInteractor, Cuckoo.Mock {
    typealias MocksType = TripsInteractor
    typealias Stubbing = __StubbingProxy_TripsInteractor
    typealias Verification = __VerificationProxy_TripsInteractor
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: TripsInteractor?

    func spy(on victim: TripsInteractor) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func configureSubscribers()  {
        
        return cuckoo_manager.call("configureSubscribers()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.configureSubscribers()
                }
            })
        
    }
    
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        
        return cuckoo_manager.call("fetchedModelAdapter() -> FetchedModelAdapter?",
            parameters: (),
            original: observed.map { o in
                return { () -> FetchedModelAdapter? in
                    o.fetchedModelAdapter()
                }
            })
        
    }
    

    struct __StubbingProxy_TripsInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func configureSubscribers() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("configureSubscribers()", parameterMatchers: matchers))
        }
        
        func fetchedModelAdapter() -> Cuckoo.StubFunction<(), Optional<FetchedModelAdapter>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("fetchedModelAdapter() -> FetchedModelAdapter?", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_TripsInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func configureSubscribers() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("configureSubscribers()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func fetchedModelAdapter() -> Cuckoo.__DoNotUse<Optional<FetchedModelAdapter>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("fetchedModelAdapter() -> FetchedModelAdapter?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class TripsInteractorStub: TripsInteractor {
    

    

    
     override func configureSubscribers()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        return DefaultValueRegistry.defaultValue(for: Optional<FetchedModelAdapter>.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Categories/CategoriesInteractor.swift at 2017-08-18 10:14:34 +0000

//
//  CategoriesInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit

class MockCategoriesInteractor: CategoriesInteractor, Cuckoo.Mock {
    typealias MocksType = CategoriesInteractor
    typealias Stubbing = __StubbingProxy_CategoriesInteractor
    typealias Verification = __VerificationProxy_CategoriesInteractor
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: CategoriesInteractor?

    func spy(on victim: CategoriesInteractor) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func configureSubscribers()  {
        
        return cuckoo_manager.call("configureSubscribers()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.configureSubscribers()
                }
            })
        
    }
    
     override func save(category: WBCategory, update: Bool)  {
        
        return cuckoo_manager.call("save(category: WBCategory, update: Bool)",
            parameters: (category, update),
            original: observed.map { o in
                return { (category: WBCategory, update: Bool) in
                    o.save(category: category, update: update)
                }
            })
        
    }
    
     override func delete(category: WBCategory)  {
        
        return cuckoo_manager.call("delete(category: WBCategory)",
            parameters: (category),
            original: observed.map { o in
                return { (category: WBCategory) in
                    o.delete(category: category)
                }
            })
        
    }
    
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        
        return cuckoo_manager.call("fetchedModelAdapter() -> FetchedModelAdapter?",
            parameters: (),
            original: observed.map { o in
                return { () -> FetchedModelAdapter? in
                    o.fetchedModelAdapter()
                }
            })
        
    }
    

    struct __StubbingProxy_CategoriesInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func configureSubscribers() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("configureSubscribers()", parameterMatchers: matchers))
        }
        
        func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(category: M1, update: M2) -> Cuckoo.StubNoReturnFunction<(WBCategory, Bool)> where M1.MatchedType == WBCategory, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(WBCategory, Bool)>] = [wrap(matchable: category) { $0.0 }, wrap(matchable: update) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub("save(category: WBCategory, update: Bool)", parameterMatchers: matchers))
        }
        
        func delete<M1: Cuckoo.Matchable>(category: M1) -> Cuckoo.StubNoReturnFunction<(WBCategory)> where M1.MatchedType == WBCategory {
            let matchers: [Cuckoo.ParameterMatcher<(WBCategory)>] = [wrap(matchable: category) { $0 }]
            return .init(stub: cuckoo_manager.createStub("delete(category: WBCategory)", parameterMatchers: matchers))
        }
        
        func fetchedModelAdapter() -> Cuckoo.StubFunction<(), Optional<FetchedModelAdapter>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("fetchedModelAdapter() -> FetchedModelAdapter?", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_CategoriesInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func configureSubscribers() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("configureSubscribers()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(category: M1, update: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == WBCategory, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(WBCategory, Bool)>] = [wrap(matchable: category) { $0.0 }, wrap(matchable: update) { $0.1 }]
            return cuckoo_manager.verify("save(category: WBCategory, update: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func delete<M1: Cuckoo.Matchable>(category: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == WBCategory {
            let matchers: [Cuckoo.ParameterMatcher<(WBCategory)>] = [wrap(matchable: category) { $0 }]
            return cuckoo_manager.verify("delete(category: WBCategory)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func fetchedModelAdapter() -> Cuckoo.__DoNotUse<Optional<FetchedModelAdapter>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("fetchedModelAdapter() -> FetchedModelAdapter?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class CategoriesInteractorStub: CategoriesInteractor {
    

    

    
     override func configureSubscribers()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func save(category: WBCategory, update: Bool)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func delete(category: WBCategory)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        return DefaultValueRegistry.defaultValue(for: Optional<FetchedModelAdapter>.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipt Move Copy/ReceiptMoveCopyRouter.swift at 2017-08-18 10:14:34 +0000

//
//  ReceiptMoveCopyRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 22/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit

class MockReceiptMoveCopyRouter: ReceiptMoveCopyRouter, Cuckoo.Mock {
    typealias MocksType = ReceiptMoveCopyRouter
    typealias Stubbing = __StubbingProxy_ReceiptMoveCopyRouter
    typealias Verification = __VerificationProxy_ReceiptMoveCopyRouter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: ReceiptMoveCopyRouter?

    func spy(on victim: ReceiptMoveCopyRouter) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func close()  {
        
        return cuckoo_manager.call("close()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.close()
                }
            })
        
    }
    

    struct __StubbingProxy_ReceiptMoveCopyRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func close() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("close()", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_ReceiptMoveCopyRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("close()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class ReceiptMoveCopyRouterStub: ReceiptMoveCopyRouter {
    

    

    
     override func close()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Distance/EditDistanceRouter.swift at 2017-08-18 10:14:34 +0000

//
//  EditDistanceRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit

class MockEditDistanceRouter: EditDistanceRouter, Cuckoo.Mock {
    typealias MocksType = EditDistanceRouter
    typealias Stubbing = __StubbingProxy_EditDistanceRouter
    typealias Verification = __VerificationProxy_EditDistanceRouter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: EditDistanceRouter?

    func spy(on victim: EditDistanceRouter) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func close()  {
        
        return cuckoo_manager.call("close()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.close()
                }
            })
        
    }
    

    struct __StubbingProxy_EditDistanceRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func close() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("close()", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_EditDistanceRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("close()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class EditDistanceRouterStub: EditDistanceRouter {
    

    

    
     override func close()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Payment Methods/PaymentMethodsPresenter.swift at 2017-08-18 10:14:34 +0000

//
//  PaymentMethodsPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit

class MockPaymentMethodsPresenter: PaymentMethodsPresenter, Cuckoo.Mock {
    typealias MocksType = PaymentMethodsPresenter
    typealias Stubbing = __StubbingProxy_PaymentMethodsPresenter
    typealias Verification = __VerificationProxy_PaymentMethodsPresenter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: PaymentMethodsPresenter?

    func spy(on victim: PaymentMethodsPresenter) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func viewHasLoaded()  {
        
        return cuckoo_manager.call("viewHasLoaded()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.viewHasLoaded()
                }
            })
        
    }
    
     override func presentAlert(title: String?, message: String)  {
        
        return cuckoo_manager.call("presentAlert(title: String?, message: String)",
            parameters: (title, message),
            original: observed.map { o in
                return { (title: String?, message: String) in
                    o.presentAlert(title: title, message: message)
                }
            })
        
    }
    
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        
        return cuckoo_manager.call("fetchedModelAdapter() -> FetchedModelAdapter?",
            parameters: (),
            original: observed.map { o in
                return { () -> FetchedModelAdapter? in
                    o.fetchedModelAdapter()
                }
            })
        
    }
    

    struct __StubbingProxy_PaymentMethodsPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func viewHasLoaded() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("viewHasLoaded()", parameterMatchers: matchers))
        }
        
        func presentAlert<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(title: M1, message: M2) -> Cuckoo.StubNoReturnFunction<(String?, String)> where M1.MatchedType == String?, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String)>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub("presentAlert(title: String?, message: String)", parameterMatchers: matchers))
        }
        
        func fetchedModelAdapter() -> Cuckoo.StubFunction<(), Optional<FetchedModelAdapter>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("fetchedModelAdapter() -> FetchedModelAdapter?", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_PaymentMethodsPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func viewHasLoaded() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("viewHasLoaded()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func presentAlert<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(title: M1, message: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String?, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String)>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }]
            return cuckoo_manager.verify("presentAlert(title: String?, message: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func fetchedModelAdapter() -> Cuckoo.__DoNotUse<Optional<FetchedModelAdapter>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("fetchedModelAdapter() -> FetchedModelAdapter?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class PaymentMethodsPresenterStub: PaymentMethodsPresenter {
    

    

    
     override func viewHasLoaded()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func presentAlert(title: String?, message: String)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        return DefaultValueRegistry.defaultValue(for: Optional<FetchedModelAdapter>.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Payment Methods/PaymentMethodsRouter.swift at 2017-08-18 10:14:34 +0000

//
//  PaymentMethodsRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit

class MockPaymentMethodsRouter: PaymentMethodsRouter, Cuckoo.Mock {
    typealias MocksType = PaymentMethodsRouter
    typealias Stubbing = __StubbingProxy_PaymentMethodsRouter
    typealias Verification = __VerificationProxy_PaymentMethodsRouter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: PaymentMethodsRouter?

    func spy(on victim: PaymentMethodsRouter) -> Self {
        observed = victim
        return self
    }

    

    

    

    struct __StubbingProxy_PaymentMethodsRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
    }


    struct __VerificationProxy_PaymentMethodsRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
    }


}

 class PaymentMethodsRouterStub: PaymentMethodsRouter {
    

    

    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Distance/EditDistancePresenter.swift at 2017-08-18 10:14:34 +0000

//
//  EditDistancePresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit

class MockEditDistancePresenter: EditDistancePresenter, Cuckoo.Mock {
    typealias MocksType = EditDistancePresenter
    typealias Stubbing = __StubbingProxy_EditDistancePresenter
    typealias Verification = __VerificationProxy_EditDistancePresenter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: EditDistancePresenter?

    func spy(on victim: EditDistancePresenter) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func setupView(data: Any)  {
        
        return cuckoo_manager.call("setupView(data: Any)",
            parameters: (data),
            original: observed.map { o in
                return { (data: Any) in
                    o.setupView(data: data)
                }
            })
        
    }
    
     override func save(distance: Distance, asNewDistance: Bool)  {
        
        return cuckoo_manager.call("save(distance: Distance, asNewDistance: Bool)",
            parameters: (distance, asNewDistance),
            original: observed.map { o in
                return { (distance: Distance, asNewDistance: Bool) in
                    o.save(distance: distance, asNewDistance: asNewDistance)
                }
            })
        
    }
    
     override func close()  {
        
        return cuckoo_manager.call("close()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.close()
                }
            })
        
    }
    

    struct __StubbingProxy_EditDistancePresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.StubNoReturnFunction<(Any)> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub("setupView(data: Any)", parameterMatchers: matchers))
        }
        
        func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(distance: M1, asNewDistance: M2) -> Cuckoo.StubNoReturnFunction<(Distance, Bool)> where M1.MatchedType == Distance, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Distance, Bool)>] = [wrap(matchable: distance) { $0.0 }, wrap(matchable: asNewDistance) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub("save(distance: Distance, asNewDistance: Bool)", parameterMatchers: matchers))
        }
        
        func close() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("close()", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_EditDistancePresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify("setupView(data: Any)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(distance: M1, asNewDistance: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Distance, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Distance, Bool)>] = [wrap(matchable: distance) { $0.0 }, wrap(matchable: asNewDistance) { $0.1 }]
            return cuckoo_manager.verify("save(distance: Distance, asNewDistance: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("close()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class EditDistancePresenterStub: EditDistancePresenter {
    

    

    
     override func setupView(data: Any)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func save(distance: Distance, asNewDistance: Bool)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func close()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipt Actions/ReceiptActionsInteractor.swift at 2017-08-18 10:14:34 +0000

//
//  ReceiptActionsInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit

class MockReceiptActionsInteractor: ReceiptActionsInteractor, Cuckoo.Mock {
    typealias MocksType = ReceiptActionsInteractor
    typealias Stubbing = __StubbingProxy_ReceiptActionsInteractor
    typealias Verification = __VerificationProxy_ReceiptActionsInteractor
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: ReceiptActionsInteractor?

    func spy(on victim: ReceiptActionsInteractor) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func attachAppInputFile(to receipt: WBReceipt)  -> Bool {
        
        return cuckoo_manager.call("attachAppInputFile(to: WBReceipt) -> Bool",
            parameters: (receipt),
            original: observed.map { o in
                return { (receipt: WBReceipt) -> Bool in
                    o.attachAppInputFile(to: receipt)
                }
            })
        
    }
    
     override func attachImage(_ image: UIImage, to receipt: WBReceipt)  -> Bool {
        
        return cuckoo_manager.call("attachImage(_: UIImage, to: WBReceipt) -> Bool",
            parameters: (image, receipt),
            original: observed.map { o in
                return { (image: UIImage, receipt: WBReceipt) -> Bool in
                    o.attachImage(image, to: receipt)
                }
            })
        
    }
    

    struct __StubbingProxy_ReceiptActionsInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func attachAppInputFile<M1: Cuckoo.Matchable>(to receipt: M1) -> Cuckoo.StubFunction<(WBReceipt), Bool> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub("attachAppInputFile(to: WBReceipt) -> Bool", parameterMatchers: matchers))
        }
        
        func attachImage<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ image: M1, to receipt: M2) -> Cuckoo.StubFunction<(UIImage, WBReceipt), Bool> where M1.MatchedType == UIImage, M2.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(UIImage, WBReceipt)>] = [wrap(matchable: image) { $0.0 }, wrap(matchable: receipt) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub("attachImage(_: UIImage, to: WBReceipt) -> Bool", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_ReceiptActionsInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func attachAppInputFile<M1: Cuckoo.Matchable>(to receipt: M1) -> Cuckoo.__DoNotUse<Bool> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify("attachAppInputFile(to: WBReceipt) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func attachImage<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ image: M1, to receipt: M2) -> Cuckoo.__DoNotUse<Bool> where M1.MatchedType == UIImage, M2.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(UIImage, WBReceipt)>] = [wrap(matchable: image) { $0.0 }, wrap(matchable: receipt) { $0.1 }]
            return cuckoo_manager.verify("attachImage(_: UIImage, to: WBReceipt) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class ReceiptActionsInteractorStub: ReceiptActionsInteractor {
    

    

    
     override func attachAppInputFile(to receipt: WBReceipt)  -> Bool {
        return DefaultValueRegistry.defaultValue(for: Bool.self)
    }
    
     override func attachImage(_ image: UIImage, to receipt: WBReceipt)  -> Bool {
        return DefaultValueRegistry.defaultValue(for: Bool.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipt Actions/ReceiptActionsRouter.swift at 2017-08-18 10:14:34 +0000

//
//  ReceiptActionsRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit

class MockReceiptActionsRouter: ReceiptActionsRouter, Cuckoo.Mock {
    typealias MocksType = ReceiptActionsRouter
    typealias Stubbing = __StubbingProxy_ReceiptActionsRouter
    typealias Verification = __VerificationProxy_ReceiptActionsRouter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: ReceiptActionsRouter?

    func spy(on victim: ReceiptActionsRouter) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func close()  {
        
        return cuckoo_manager.call("close()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.close()
                }
            })
        
    }
    
     override func openMove(receipt: WBReceipt)  {
        
        return cuckoo_manager.call("openMove(receipt: WBReceipt)",
            parameters: (receipt),
            original: observed.map { o in
                return { (receipt: WBReceipt) in
                    o.openMove(receipt: receipt)
                }
            })
        
    }
    
     override func openCopy(receipt: WBReceipt)  {
        
        return cuckoo_manager.call("openCopy(receipt: WBReceipt)",
            parameters: (receipt),
            original: observed.map { o in
                return { (receipt: WBReceipt) in
                    o.openCopy(receipt: receipt)
                }
            })
        
    }
    

    struct __StubbingProxy_ReceiptActionsRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func close() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("close()", parameterMatchers: matchers))
        }
        
        func openMove<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.StubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub("openMove(receipt: WBReceipt)", parameterMatchers: matchers))
        }
        
        func openCopy<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.StubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub("openCopy(receipt: WBReceipt)", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_ReceiptActionsRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("close()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func openMove<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify("openMove(receipt: WBReceipt)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func openCopy<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify("openCopy(receipt: WBReceipt)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class ReceiptActionsRouterStub: ReceiptActionsRouter {
    

    

    
     override func close()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openMove(receipt: WBReceipt)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openCopy(receipt: WBReceipt)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Trip/EditTripRouter.swift at 2017-08-18 10:14:34 +0000

//
//  EditTripRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit

class MockEditTripRouter: EditTripRouter, Cuckoo.Mock {
    typealias MocksType = EditTripRouter
    typealias Stubbing = __StubbingProxy_EditTripRouter
    typealias Verification = __VerificationProxy_EditTripRouter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: EditTripRouter?

    func spy(on victim: EditTripRouter) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func close()  {
        
        return cuckoo_manager.call("close()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.close()
                }
            })
        
    }
    

    struct __StubbingProxy_EditTripRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func close() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("close()", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_EditTripRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("close()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class EditTripRouterStub: EditTripRouter {
    

    

    
     override func close()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Receipt/EditReceiptInteractor.swift at 2017-08-18 10:14:34 +0000

//
//  EditReceiptInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit

class MockEditReceiptInteractor: EditReceiptInteractor, Cuckoo.Mock {
    typealias MocksType = EditReceiptInteractor
    typealias Stubbing = __StubbingProxy_EditReceiptInteractor
    typealias Verification = __VerificationProxy_EditReceiptInteractor
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: EditReceiptInteractor?

    func spy(on victim: EditReceiptInteractor) -> Self {
        observed = victim
        return self
    }

    
    // ["name": "receiptImage", "accesibility": "", "@type": "InstanceVariable", "type": "UIImage?", "isReadOnly": false]
     override var receiptImage: UIImage? {
        get {
            return cuckoo_manager.getter("receiptImage", original: observed.map { o in return { () -> UIImage? in o.receiptImage }})
        }
        
        set {
            cuckoo_manager.setter("receiptImage", value: newValue, original: observed != nil ? { self.observed?.receiptImage = $0 } : nil)
        }
        
    }
    

    

    
     override func configureSubscribers()  {
        
        return cuckoo_manager.call("configureSubscribers()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.configureSubscribers()
                }
            })
        
    }
    

    struct __StubbingProxy_EditReceiptInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var receiptImage: Cuckoo.ToBeStubbedProperty<UIImage?> {
            return .init(manager: cuckoo_manager, name: "receiptImage")
        }
        
        
        func configureSubscribers() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("configureSubscribers()", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_EditReceiptInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        
        var receiptImage: Cuckoo.VerifyProperty<UIImage?> {
            return .init(manager: cuckoo_manager, name: "receiptImage", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        

        
        @discardableResult
        func configureSubscribers() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("configureSubscribers()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class EditReceiptInteractorStub: EditReceiptInteractor {
    
     override var receiptImage: UIImage? {
        get {
            return DefaultValueRegistry.defaultValue(for: (UIImage?).self)
        }
        
        set { }
        
    }
    

    

    
     override func configureSubscribers()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Payment Methods/PaymentMethodsInteractor.swift at 2017-08-18 10:14:34 +0000

//
//  PaymentMethodsInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit

class MockPaymentMethodsInteractor: PaymentMethodsInteractor, Cuckoo.Mock {
    typealias MocksType = PaymentMethodsInteractor
    typealias Stubbing = __StubbingProxy_PaymentMethodsInteractor
    typealias Verification = __VerificationProxy_PaymentMethodsInteractor
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: PaymentMethodsInteractor?

    func spy(on victim: PaymentMethodsInteractor) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func configureSubscribers()  {
        
        return cuckoo_manager.call("configureSubscribers()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.configureSubscribers()
                }
            })
        
    }
    
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        
        return cuckoo_manager.call("fetchedModelAdapter() -> FetchedModelAdapter?",
            parameters: (),
            original: observed.map { o in
                return { () -> FetchedModelAdapter? in
                    o.fetchedModelAdapter()
                }
            })
        
    }
    
     override func save(paymentMethod: PaymentMethod, update: Bool)  {
        
        return cuckoo_manager.call("save(paymentMethod: PaymentMethod, update: Bool)",
            parameters: (paymentMethod, update),
            original: observed.map { o in
                return { (paymentMethod: PaymentMethod, update: Bool) in
                    o.save(paymentMethod: paymentMethod, update: update)
                }
            })
        
    }
    
     override func delete(paymentMethod: PaymentMethod)  {
        
        return cuckoo_manager.call("delete(paymentMethod: PaymentMethod)",
            parameters: (paymentMethod),
            original: observed.map { o in
                return { (paymentMethod: PaymentMethod) in
                    o.delete(paymentMethod: paymentMethod)
                }
            })
        
    }
    

    struct __StubbingProxy_PaymentMethodsInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func configureSubscribers() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("configureSubscribers()", parameterMatchers: matchers))
        }
        
        func fetchedModelAdapter() -> Cuckoo.StubFunction<(), Optional<FetchedModelAdapter>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("fetchedModelAdapter() -> FetchedModelAdapter?", parameterMatchers: matchers))
        }
        
        func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(paymentMethod: M1, update: M2) -> Cuckoo.StubNoReturnFunction<(PaymentMethod, Bool)> where M1.MatchedType == PaymentMethod, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(PaymentMethod, Bool)>] = [wrap(matchable: paymentMethod) { $0.0 }, wrap(matchable: update) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub("save(paymentMethod: PaymentMethod, update: Bool)", parameterMatchers: matchers))
        }
        
        func delete<M1: Cuckoo.Matchable>(paymentMethod: M1) -> Cuckoo.StubNoReturnFunction<(PaymentMethod)> where M1.MatchedType == PaymentMethod {
            let matchers: [Cuckoo.ParameterMatcher<(PaymentMethod)>] = [wrap(matchable: paymentMethod) { $0 }]
            return .init(stub: cuckoo_manager.createStub("delete(paymentMethod: PaymentMethod)", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_PaymentMethodsInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func configureSubscribers() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("configureSubscribers()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func fetchedModelAdapter() -> Cuckoo.__DoNotUse<Optional<FetchedModelAdapter>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("fetchedModelAdapter() -> FetchedModelAdapter?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(paymentMethod: M1, update: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == PaymentMethod, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(PaymentMethod, Bool)>] = [wrap(matchable: paymentMethod) { $0.0 }, wrap(matchable: update) { $0.1 }]
            return cuckoo_manager.verify("save(paymentMethod: PaymentMethod, update: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func delete<M1: Cuckoo.Matchable>(paymentMethod: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == PaymentMethod {
            let matchers: [Cuckoo.ParameterMatcher<(PaymentMethod)>] = [wrap(matchable: paymentMethod) { $0 }]
            return cuckoo_manager.verify("delete(paymentMethod: PaymentMethod)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class PaymentMethodsInteractorStub: PaymentMethodsInteractor {
    

    

    
     override func configureSubscribers()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        return DefaultValueRegistry.defaultValue(for: Optional<FetchedModelAdapter>.self)
    }
    
     override func save(paymentMethod: PaymentMethod, update: Bool)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func delete(paymentMethod: PaymentMethod)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Columns/ColumnsRouter.swift at 2017-08-18 10:14:34 +0000

//
//  ColumnsRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit

class MockColumnsRouter: ColumnsRouter, Cuckoo.Mock {
    typealias MocksType = ColumnsRouter
    typealias Stubbing = __StubbingProxy_ColumnsRouter
    typealias Verification = __VerificationProxy_ColumnsRouter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: ColumnsRouter?

    func spy(on victim: ColumnsRouter) -> Self {
        observed = victim
        return self
    }

    

    

    

    struct __StubbingProxy_ColumnsRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
    }


    struct __VerificationProxy_ColumnsRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
    }


}

 class ColumnsRouterStub: ColumnsRouter {
    

    

    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Trip Distances/TripDistancesPresenter.swift at 2017-08-18 10:14:34 +0000

//
//  TripDistancesPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit

class MockTripDistancesPresenter: TripDistancesPresenter, Cuckoo.Mock {
    typealias MocksType = TripDistancesPresenter
    typealias Stubbing = __StubbingProxy_TripDistancesPresenter
    typealias Verification = __VerificationProxy_TripDistancesPresenter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: TripDistancesPresenter?

    func spy(on victim: TripDistancesPresenter) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func fetchedModelAdapter(for trip: WBTrip)  -> FetchedModelAdapter {
        
        return cuckoo_manager.call("fetchedModelAdapter(for: WBTrip) -> FetchedModelAdapter",
            parameters: (trip),
            original: observed.map { o in
                return { (trip: WBTrip) -> FetchedModelAdapter in
                    o.fetchedModelAdapter(for: trip)
                }
            })
        
    }
    
     override func delete(distance: Distance)  {
        
        return cuckoo_manager.call("delete(distance: Distance)",
            parameters: (distance),
            original: observed.map { o in
                return { (distance: Distance) in
                    o.delete(distance: distance)
                }
            })
        
    }
    
     override func presentEditDistance(with data: Any?)  {
        
        return cuckoo_manager.call("presentEditDistance(with: Any?)",
            parameters: (data),
            original: observed.map { o in
                return { (data: Any?) in
                    o.presentEditDistance(with: data)
                }
            })
        
    }
    
     override func setupView(data: Any)  {
        
        return cuckoo_manager.call("setupView(data: Any)",
            parameters: (data),
            original: observed.map { o in
                return { (data: Any) in
                    o.setupView(data: data)
                }
            })
        
    }
    

    struct __StubbingProxy_TripDistancesPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func fetchedModelAdapter<M1: Cuckoo.Matchable>(for trip: M1) -> Cuckoo.StubFunction<(WBTrip), FetchedModelAdapter> where M1.MatchedType == WBTrip {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
            return .init(stub: cuckoo_manager.createStub("fetchedModelAdapter(for: WBTrip) -> FetchedModelAdapter", parameterMatchers: matchers))
        }
        
        func delete<M1: Cuckoo.Matchable>(distance: M1) -> Cuckoo.StubNoReturnFunction<(Distance)> where M1.MatchedType == Distance {
            let matchers: [Cuckoo.ParameterMatcher<(Distance)>] = [wrap(matchable: distance) { $0 }]
            return .init(stub: cuckoo_manager.createStub("delete(distance: Distance)", parameterMatchers: matchers))
        }
        
        func presentEditDistance<M1: Cuckoo.Matchable>(with data: M1) -> Cuckoo.StubNoReturnFunction<(Any?)> where M1.MatchedType == Any? {
            let matchers: [Cuckoo.ParameterMatcher<(Any?)>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub("presentEditDistance(with: Any?)", parameterMatchers: matchers))
        }
        
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.StubNoReturnFunction<(Any)> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub("setupView(data: Any)", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_TripDistancesPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func fetchedModelAdapter<M1: Cuckoo.Matchable>(for trip: M1) -> Cuckoo.__DoNotUse<FetchedModelAdapter> where M1.MatchedType == WBTrip {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
            return cuckoo_manager.verify("fetchedModelAdapter(for: WBTrip) -> FetchedModelAdapter", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func delete<M1: Cuckoo.Matchable>(distance: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Distance {
            let matchers: [Cuckoo.ParameterMatcher<(Distance)>] = [wrap(matchable: distance) { $0 }]
            return cuckoo_manager.verify("delete(distance: Distance)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func presentEditDistance<M1: Cuckoo.Matchable>(with data: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Any? {
            let matchers: [Cuckoo.ParameterMatcher<(Any?)>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify("presentEditDistance(with: Any?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify("setupView(data: Any)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class TripDistancesPresenterStub: TripDistancesPresenter {
    

    

    
     override func fetchedModelAdapter(for trip: WBTrip)  -> FetchedModelAdapter {
        return DefaultValueRegistry.defaultValue(for: FetchedModelAdapter.self)
    }
    
     override func delete(distance: Distance)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func presentEditDistance(with data: Any?)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func setupView(data: Any)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Trip/EditTripPresenter.swift at 2017-08-18 10:14:34 +0000

//
//  EditTripPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit

class MockEditTripPresenter: EditTripPresenter, Cuckoo.Mock {
    typealias MocksType = EditTripPresenter
    typealias Stubbing = __StubbingProxy_EditTripPresenter
    typealias Verification = __VerificationProxy_EditTripPresenter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: EditTripPresenter?

    func spy(on victim: EditTripPresenter) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func viewHasLoaded()  {
        
        return cuckoo_manager.call("viewHasLoaded()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.viewHasLoaded()
                }
            })
        
    }
    
     override func setupView(data: Any)  {
        
        return cuckoo_manager.call("setupView(data: Any)",
            parameters: (data),
            original: observed.map { o in
                return { (data: Any) in
                    o.setupView(data: data)
                }
            })
        
    }
    
     override func close()  {
        
        return cuckoo_manager.call("close()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.close()
                }
            })
        
    }
    
     override func presentAlert(title: String?, message: String)  {
        
        return cuckoo_manager.call("presentAlert(title: String?, message: String)",
            parameters: (title, message),
            original: observed.map { o in
                return { (title: String?, message: String) in
                    o.presentAlert(title: title, message: message)
                }
            })
        
    }
    

    struct __StubbingProxy_EditTripPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func viewHasLoaded() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("viewHasLoaded()", parameterMatchers: matchers))
        }
        
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.StubNoReturnFunction<(Any)> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub("setupView(data: Any)", parameterMatchers: matchers))
        }
        
        func close() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("close()", parameterMatchers: matchers))
        }
        
        func presentAlert<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(title: M1, message: M2) -> Cuckoo.StubNoReturnFunction<(String?, String)> where M1.MatchedType == String?, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String)>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub("presentAlert(title: String?, message: String)", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_EditTripPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func viewHasLoaded() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("viewHasLoaded()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify("setupView(data: Any)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("close()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func presentAlert<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(title: M1, message: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String?, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String?, String)>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }]
            return cuckoo_manager.verify("presentAlert(title: String?, message: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class EditTripPresenterStub: EditTripPresenter {
    

    

    
     override func viewHasLoaded()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func setupView(data: Any)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func close()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func presentAlert(title: String?, message: String)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipt Move Copy/ReceiptMoveCopyPresenter.swift at 2017-08-18 10:14:34 +0000

//
//  ReceiptMoveCopyPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 22/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit

class MockReceiptMoveCopyPresenter: ReceiptMoveCopyPresenter, Cuckoo.Mock {
    typealias MocksType = ReceiptMoveCopyPresenter
    typealias Stubbing = __StubbingProxy_ReceiptMoveCopyPresenter
    typealias Verification = __VerificationProxy_ReceiptMoveCopyPresenter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: ReceiptMoveCopyPresenter?

    func spy(on victim: ReceiptMoveCopyPresenter) -> Self {
        observed = victim
        return self
    }

    
    // ["name": "isCopyOrMove", "accesibility": "", "@type": "InstanceVariable", "type": "Bool!", "isReadOnly": false]
     override var isCopyOrMove: Bool! {
        get {
            return cuckoo_manager.getter("isCopyOrMove", original: observed.map { o in return { () -> Bool! in o.isCopyOrMove }})
        }
        
        set {
            cuckoo_manager.setter("isCopyOrMove", value: newValue, original: observed != nil ? { self.observed?.isCopyOrMove = $0 } : nil)
        }
        
    }
    
    // ["name": "receipt", "accesibility": "", "@type": "InstanceVariable", "type": "WBReceipt!", "isReadOnly": false]
     override var receipt: WBReceipt! {
        get {
            return cuckoo_manager.getter("receipt", original: observed.map { o in return { () -> WBReceipt! in o.receipt }})
        }
        
        set {
            cuckoo_manager.setter("receipt", value: newValue, original: observed != nil ? { self.observed?.receipt = $0 } : nil)
        }
        
    }
    

    

    
     override func viewHasLoaded()  {
        
        return cuckoo_manager.call("viewHasLoaded()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.viewHasLoaded()
                }
            })
        
    }
    
     override func setupView(data: Any)  {
        
        return cuckoo_manager.call("setupView(data: Any)",
            parameters: (data),
            original: observed.map { o in
                return { (data: Any) in
                    o.setupView(data: data)
                }
            })
        
    }
    
     override func close()  {
        
        return cuckoo_manager.call("close()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.close()
                }
            })
        
    }
    

    struct __StubbingProxy_ReceiptMoveCopyPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var isCopyOrMove: Cuckoo.ToBeStubbedProperty<Bool?> {
            return .init(manager: cuckoo_manager, name: "isCopyOrMove")
        }
        
        var receipt: Cuckoo.ToBeStubbedProperty<WBReceipt?> {
            return .init(manager: cuckoo_manager, name: "receipt")
        }
        
        
        func viewHasLoaded() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("viewHasLoaded()", parameterMatchers: matchers))
        }
        
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.StubNoReturnFunction<(Any)> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub("setupView(data: Any)", parameterMatchers: matchers))
        }
        
        func close() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("close()", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_ReceiptMoveCopyPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        
        var isCopyOrMove: Cuckoo.VerifyProperty<Bool?> {
            return .init(manager: cuckoo_manager, name: "isCopyOrMove", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var receipt: Cuckoo.VerifyProperty<WBReceipt?> {
            return .init(manager: cuckoo_manager, name: "receipt", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        

        
        @discardableResult
        func viewHasLoaded() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("viewHasLoaded()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify("setupView(data: Any)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("close()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class ReceiptMoveCopyPresenterStub: ReceiptMoveCopyPresenter {
    
     override var isCopyOrMove: Bool! {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool!).self)
        }
        
        set { }
        
    }
    
     override var receipt: WBReceipt! {
        get {
            return DefaultValueRegistry.defaultValue(for: (WBReceipt!).self)
        }
        
        set { }
        
    }
    

    

    
     override func viewHasLoaded()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func setupView(data: Any)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func close()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipt Actions/ReceiptActionsPresenter.swift at 2017-08-18 10:14:34 +0000

//
//  ReceiptActionsPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit

class MockReceiptActionsPresenter: ReceiptActionsPresenter, Cuckoo.Mock {
    typealias MocksType = ReceiptActionsPresenter
    typealias Stubbing = __StubbingProxy_ReceiptActionsPresenter
    typealias Verification = __VerificationProxy_ReceiptActionsPresenter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: ReceiptActionsPresenter?

    func spy(on victim: ReceiptActionsPresenter) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func setupView(data: Any)  {
        
        return cuckoo_manager.call("setupView(data: Any)",
            parameters: (data),
            original: observed.map { o in
                return { (data: Any) in
                    o.setupView(data: data)
                }
            })
        
    }
    
     override func viewHasLoaded()  {
        
        return cuckoo_manager.call("viewHasLoaded()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.viewHasLoaded()
                }
            })
        
    }
    
     override func configureSubscribers()  {
        
        return cuckoo_manager.call("configureSubscribers()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.configureSubscribers()
                }
            })
        
    }
    

    struct __StubbingProxy_ReceiptActionsPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.StubNoReturnFunction<(Any)> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub("setupView(data: Any)", parameterMatchers: matchers))
        }
        
        func viewHasLoaded() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("viewHasLoaded()", parameterMatchers: matchers))
        }
        
        func configureSubscribers() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("configureSubscribers()", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_ReceiptActionsPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify("setupView(data: Any)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func viewHasLoaded() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("viewHasLoaded()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func configureSubscribers() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("configureSubscribers()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class ReceiptActionsPresenterStub: ReceiptActionsPresenter {
    

    

    
     override func setupView(data: Any)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func viewHasLoaded()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func configureSubscribers()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Categories/CategoriesRouter.swift at 2017-08-18 10:14:34 +0000

//
//  CategoriesRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit

class MockCategoriesRouter: CategoriesRouter, Cuckoo.Mock {
    typealias MocksType = CategoriesRouter
    typealias Stubbing = __StubbingProxy_CategoriesRouter
    typealias Verification = __VerificationProxy_CategoriesRouter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: CategoriesRouter?

    func spy(on victim: CategoriesRouter) -> Self {
        observed = victim
        return self
    }

    

    

    

    struct __StubbingProxy_CategoriesRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
    }


    struct __VerificationProxy_CategoriesRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
    }


}

 class CategoriesRouterStub: CategoriesRouter {
    

    

    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Columns/ColumnsInteractor.swift at 2017-08-18 10:14:34 +0000

//
//  ColumnsInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit

class MockColumnsInteractor: ColumnsInteractor, Cuckoo.Mock {
    typealias MocksType = ColumnsInteractor
    typealias Stubbing = __StubbingProxy_ColumnsInteractor
    typealias Verification = __VerificationProxy_ColumnsInteractor
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: ColumnsInteractor?

    func spy(on victim: ColumnsInteractor) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func columns(forCSV: Bool)  -> Observable<[Column]> {
        
        return cuckoo_manager.call("columns(forCSV: Bool) -> Observable<[Column]>",
            parameters: (forCSV),
            original: observed.map { o in
                return { (forCSV: Bool) -> Observable<[Column]> in
                    o.columns(forCSV: forCSV)
                }
            })
        
    }
    
     override func update(columns: [Column], forCSV: Bool)  {
        
        return cuckoo_manager.call("update(columns: [Column], forCSV: Bool)",
            parameters: (columns, forCSV),
            original: observed.map { o in
                return { (columns: [Column], forCSV: Bool) in
                    o.update(columns: columns, forCSV: forCSV)
                }
            })
        
    }
    

    struct __StubbingProxy_ColumnsInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func columns<M1: Cuckoo.Matchable>(forCSV: M1) -> Cuckoo.StubFunction<(Bool), Observable<[Column]>> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: forCSV) { $0 }]
            return .init(stub: cuckoo_manager.createStub("columns(forCSV: Bool) -> Observable<[Column]>", parameterMatchers: matchers))
        }
        
        func update<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(columns: M1, forCSV: M2) -> Cuckoo.StubNoReturnFunction<([Column], Bool)> where M1.MatchedType == [Column], M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<([Column], Bool)>] = [wrap(matchable: columns) { $0.0 }, wrap(matchable: forCSV) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub("update(columns: [Column], forCSV: Bool)", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_ColumnsInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func columns<M1: Cuckoo.Matchable>(forCSV: M1) -> Cuckoo.__DoNotUse<Observable<[Column]>> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: forCSV) { $0 }]
            return cuckoo_manager.verify("columns(forCSV: Bool) -> Observable<[Column]>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func update<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(columns: M1, forCSV: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == [Column], M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<([Column], Bool)>] = [wrap(matchable: columns) { $0.0 }, wrap(matchable: forCSV) { $0.1 }]
            return cuckoo_manager.verify("update(columns: [Column], forCSV: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class ColumnsInteractorStub: ColumnsInteractor {
    

    

    
     override func columns(forCSV: Bool)  -> Observable<[Column]> {
        return DefaultValueRegistry.defaultValue(for: Observable<[Column]>.self)
    }
    
     override func update(columns: [Column], forCSV: Bool)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Receipt/EditReceiptPresenter.swift at 2017-08-18 10:14:34 +0000

//
//  EditReceiptPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit

class MockEditReceiptPresenter: EditReceiptPresenter, Cuckoo.Mock {
    typealias MocksType = EditReceiptPresenter
    typealias Stubbing = __StubbingProxy_EditReceiptPresenter
    typealias Verification = __VerificationProxy_EditReceiptPresenter
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: EditReceiptPresenter?

    func spy(on victim: EditReceiptPresenter) -> Self {
        observed = victim
        return self
    }

    

    

    
     override func viewHasLoaded()  {
        
        return cuckoo_manager.call("viewHasLoaded()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.viewHasLoaded()
                }
            })
        
    }
    
     override func setupView(data: Any)  {
        
        return cuckoo_manager.call("setupView(data: Any)",
            parameters: (data),
            original: observed.map { o in
                return { (data: Any) in
                    o.setupView(data: data)
                }
            })
        
    }
    
     override func close()  {
        
        return cuckoo_manager.call("close()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.close()
                }
            })
        
    }
    
     override func present(errorDescription: String)  {
        
        return cuckoo_manager.call("present(errorDescription: String)",
            parameters: (errorDescription),
            original: observed.map { o in
                return { (errorDescription: String) in
                    o.present(errorDescription: errorDescription)
                }
            })
        
    }
    

    struct __StubbingProxy_EditReceiptPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func viewHasLoaded() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("viewHasLoaded()", parameterMatchers: matchers))
        }
        
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.StubNoReturnFunction<(Any)> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub("setupView(data: Any)", parameterMatchers: matchers))
        }
        
        func close() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("close()", parameterMatchers: matchers))
        }
        
        func present<M1: Cuckoo.Matchable>(errorDescription: M1) -> Cuckoo.StubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: errorDescription) { $0 }]
            return .init(stub: cuckoo_manager.createStub("present(errorDescription: String)", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_EditReceiptPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func viewHasLoaded() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("viewHasLoaded()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Any {
            let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify("setupView(data: Any)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func close() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("close()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func present<M1: Cuckoo.Matchable>(errorDescription: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: errorDescription) { $0 }]
            return cuckoo_manager.verify("present(errorDescription: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class EditReceiptPresenterStub: EditReceiptPresenter {
    

    

    
     override func viewHasLoaded()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func setupView(data: Any)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func close()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func present(errorDescription: String)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipts/ReceiptsInteractor.swift at 2017-08-18 10:14:34 +0000

//
//  ReceiptsInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Viperit

class MockReceiptsInteractor: ReceiptsInteractor, Cuckoo.Mock {
    typealias MocksType = ReceiptsInteractor
    typealias Stubbing = __StubbingProxy_ReceiptsInteractor
    typealias Verification = __VerificationProxy_ReceiptsInteractor
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: ReceiptsInteractor?

    func spy(on victim: ReceiptsInteractor) -> Self {
        observed = victim
        return self
    }

    
    // ["name": "fetchedModelAdapter", "accesibility": "", "@type": "InstanceVariable", "type": "FetchedModelAdapter!", "isReadOnly": false]
     override var fetchedModelAdapter: FetchedModelAdapter! {
        get {
            return cuckoo_manager.getter("fetchedModelAdapter", original: observed.map { o in return { () -> FetchedModelAdapter! in o.fetchedModelAdapter }})
        }
        
        set {
            cuckoo_manager.setter("fetchedModelAdapter", value: newValue, original: observed != nil ? { self.observed?.fetchedModelAdapter = $0 } : nil)
        }
        
    }
    
    // ["name": "trip", "accesibility": "", "@type": "InstanceVariable", "type": "WBTrip!", "isReadOnly": false]
     override var trip: WBTrip! {
        get {
            return cuckoo_manager.getter("trip", original: observed.map { o in return { () -> WBTrip! in o.trip }})
        }
        
        set {
            cuckoo_manager.setter("trip", value: newValue, original: observed != nil ? { self.observed?.trip = $0 } : nil)
        }
        
    }
    

    

    
     override func configureSubscribers()  {
        
        return cuckoo_manager.call("configureSubscribers()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.configureSubscribers()
                }
            })
        
    }
    
     override func distanceReceipts()  -> [WBReceipt] {
        
        return cuckoo_manager.call("distanceReceipts() -> [WBReceipt]",
            parameters: (),
            original: observed.map { o in
                return { () -> [WBReceipt] in
                    o.distanceReceipts()
                }
            })
        
    }
    
     override func nextID()  -> String {
        
        return cuckoo_manager.call("nextID() -> String",
            parameters: (),
            original: observed.map { o in
                return { () -> String in
                    o.nextID()
                }
            })
        
    }
    
     override func fetchedAdapter(for trip: WBTrip)  -> FetchedModelAdapter {
        
        return cuckoo_manager.call("fetchedAdapter(for: WBTrip) -> FetchedModelAdapter",
            parameters: (trip),
            original: observed.map { o in
                return { (trip: WBTrip) -> FetchedModelAdapter in
                    o.fetchedAdapter(for: trip)
                }
            })
        
    }
    
     override func swapUpReceipt(_ receipt: WBReceipt)  {
        
        return cuckoo_manager.call("swapUpReceipt(_: WBReceipt)",
            parameters: (receipt),
            original: observed.map { o in
                return { (receipt: WBReceipt) in
                    o.swapUpReceipt(receipt)
                }
            })
        
    }
    
     override func swapDownReceipt(_ receipt: WBReceipt)  {
        
        return cuckoo_manager.call("swapDownReceipt(_: WBReceipt)",
            parameters: (receipt),
            original: observed.map { o in
                return { (receipt: WBReceipt) in
                    o.swapDownReceipt(receipt)
                }
            })
        
    }
    

    struct __StubbingProxy_ReceiptsInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var fetchedModelAdapter: Cuckoo.ToBeStubbedProperty<FetchedModelAdapter?> {
            return .init(manager: cuckoo_manager, name: "fetchedModelAdapter")
        }
        
        var trip: Cuckoo.ToBeStubbedProperty<WBTrip?> {
            return .init(manager: cuckoo_manager, name: "trip")
        }
        
        
        func configureSubscribers() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("configureSubscribers()", parameterMatchers: matchers))
        }
        
        func distanceReceipts() -> Cuckoo.StubFunction<(), [WBReceipt]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("distanceReceipts() -> [WBReceipt]", parameterMatchers: matchers))
        }
        
        func nextID() -> Cuckoo.StubFunction<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("nextID() -> String", parameterMatchers: matchers))
        }
        
        func fetchedAdapter<M1: Cuckoo.Matchable>(for trip: M1) -> Cuckoo.StubFunction<(WBTrip), FetchedModelAdapter> where M1.MatchedType == WBTrip {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
            return .init(stub: cuckoo_manager.createStub("fetchedAdapter(for: WBTrip) -> FetchedModelAdapter", parameterMatchers: matchers))
        }
        
        func swapUpReceipt<M1: Cuckoo.Matchable>(_ receipt: M1) -> Cuckoo.StubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub("swapUpReceipt(_: WBReceipt)", parameterMatchers: matchers))
        }
        
        func swapDownReceipt<M1: Cuckoo.Matchable>(_ receipt: M1) -> Cuckoo.StubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return .init(stub: cuckoo_manager.createStub("swapDownReceipt(_: WBReceipt)", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_ReceiptsInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        
        var fetchedModelAdapter: Cuckoo.VerifyProperty<FetchedModelAdapter?> {
            return .init(manager: cuckoo_manager, name: "fetchedModelAdapter", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var trip: Cuckoo.VerifyProperty<WBTrip?> {
            return .init(manager: cuckoo_manager, name: "trip", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        

        
        @discardableResult
        func configureSubscribers() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("configureSubscribers()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func distanceReceipts() -> Cuckoo.__DoNotUse<[WBReceipt]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("distanceReceipts() -> [WBReceipt]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func nextID() -> Cuckoo.__DoNotUse<String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("nextID() -> String", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func fetchedAdapter<M1: Cuckoo.Matchable>(for trip: M1) -> Cuckoo.__DoNotUse<FetchedModelAdapter> where M1.MatchedType == WBTrip {
            let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
            return cuckoo_manager.verify("fetchedAdapter(for: WBTrip) -> FetchedModelAdapter", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func swapUpReceipt<M1: Cuckoo.Matchable>(_ receipt: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify("swapUpReceipt(_: WBReceipt)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func swapDownReceipt<M1: Cuckoo.Matchable>(_ receipt: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == WBReceipt {
            let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
            return cuckoo_manager.verify("swapDownReceipt(_: WBReceipt)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class ReceiptsInteractorStub: ReceiptsInteractor {
    
     override var fetchedModelAdapter: FetchedModelAdapter! {
        get {
            return DefaultValueRegistry.defaultValue(for: (FetchedModelAdapter!).self)
        }
        
        set { }
        
    }
    
     override var trip: WBTrip! {
        get {
            return DefaultValueRegistry.defaultValue(for: (WBTrip!).self)
        }
        
        set { }
        
    }
    

    

    
     override func configureSubscribers()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func distanceReceipts()  -> [WBReceipt] {
        return DefaultValueRegistry.defaultValue(for: [WBReceipt].self)
    }
    
     override func nextID()  -> String {
        return DefaultValueRegistry.defaultValue(for: String.self)
    }
    
     override func fetchedAdapter(for trip: WBTrip)  -> FetchedModelAdapter {
        return DefaultValueRegistry.defaultValue(for: FetchedModelAdapter.self)
    }
    
     override func swapUpReceipt(_ receipt: WBReceipt)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func swapDownReceipt(_ receipt: WBReceipt)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}



