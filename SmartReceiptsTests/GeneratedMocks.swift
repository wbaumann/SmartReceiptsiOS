// MARK: - Mocks generated from file: SmartReceipts/Modules/Generate Report/GenerateReportPresenter.swift at 2017-06-15 21:12:35 +0000

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




// MARK: - Mocks generated from file: SmartReceipts/Modules/Generate Report/GenerateReportInteractor.swift at 2017-06-15 21:12:35 +0000

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




// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Distance/EditDistancePresenter.swift at 2017-06-15 21:12:35 +0000

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




// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Trip/EditTripRouter.swift at 2017-06-15 21:12:35 +0000

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




// MARK: - Mocks generated from file: SmartReceipts/Modules/Trips/TripsPresenter.swift at 2017-06-15 21:12:35 +0000

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




// MARK: - Mocks generated from file: SmartReceipts/Modules/Trips/TripsRouter.swift at 2017-06-15 21:12:35 +0000

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




// MARK: - Mocks generated from file: SmartReceipts/Modules/Generate Report/GenerateReportRouter.swift at 2017-06-15 21:12:35 +0000

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




// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Distance/EditDistanceInteractor.swift at 2017-06-15 21:12:35 +0000

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




// MARK: - Mocks generated from file: SmartReceipts/Modules/Trip Distances/TripDistancesInteractor.swift at 2017-06-15 21:12:35 +0000

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




// MARK: - Mocks generated from file: SmartReceipts/Modules/Trip Distances/TripDistancesPresenter.swift at 2017-06-15 21:12:35 +0000

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




// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Trip/EditTripInteractor.swift at 2017-06-15 21:12:35 +0000

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
    
     override func onSaveError()  {
        
        return cuckoo_manager.call("onSaveError()",
            parameters: (),
            original: observed.map { o in
                return { () in
                    o.onSaveError()
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
        
        func onSaveError() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("onSaveError()", parameterMatchers: matchers))
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
        func onSaveError() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("onSaveError()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class EditTripInteractorStub: EditTripInteractor {
    

    

    
     override func configureSubscribers()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func onSaveError()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Trip/EditTripPresenter.swift at 2017-06-15 21:12:35 +0000

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




// MARK: - Mocks generated from file: SmartReceipts/Modules/Trips/TripsInteractor.swift at 2017-06-15 21:12:35 +0000

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




// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Distance/EditDistanceRouter.swift at 2017-06-15 21:12:35 +0000

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



