// MARK: - Mocks generated from file: SmartReceipts/Modules/Generate Report/GenerateReportPresenter.swift at 2017-06-07 19:41:01 +0000

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

    

    

    

    struct __StubbingProxy_GenerateReportPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
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

        

        
    }


}

 class GenerateReportPresenterStub: GenerateReportPresenter {
    

    

    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Trip Distances/TripDistancesInteractor.swift at 2017-06-07 19:41:01 +0000

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




// MARK: - Mocks generated from file: SmartReceipts/Modules/Trip Distances/TripDistancesPresenter.swift at 2017-06-07 19:41:01 +0000

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




// MARK: - Mocks generated from file: SmartReceipts/Modules/Generate Report/GenerateReportInteractor.swift at 2017-06-07 19:41:01 +0000

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

    

    

    

    struct __StubbingProxy_GenerateReportInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
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

        

        
    }


}

 class GenerateReportInteractorStub: GenerateReportInteractor {
    

    

    
}




// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Distance/EditDistancePresenter.swift at 2017-06-07 19:41:01 +0000

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




// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Distance/EditDistanceRouter.swift at 2017-06-07 19:41:01 +0000

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




// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Distance/EditDistanceInteractor.swift at 2017-06-07 19:41:01 +0000

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



