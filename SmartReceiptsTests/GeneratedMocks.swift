// MARK: - Mocks generated from file: SmartReceipts/Modules/Auth/AuthInteractor.swift
//
//  AuthInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Alamofire
import Foundation
import RxSwift
import Toaster
import Viperit

class MockAuthInteractor: AuthInteractor, Cuckoo.ClassMock {
    typealias MocksType = AuthInteractor
    typealias Stubbing = __StubbingProxy_AuthInteractor
    typealias Verification = __VerificationProxy_AuthInteractor
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "login", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "AnyObserver<Credentials>", "isReadOnly": true, "accessibility": ""]
     override var login: AnyObserver<Credentials> {
        get {
            
            return cuckoo_manager.getter("login", superclassCall: super.login)
            
        }
        
    }
    
    // ["name": "signup", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "AnyObserver<Credentials>", "isReadOnly": true, "accessibility": ""]
     override var signup: AnyObserver<Credentials> {
        get {
            
            return cuckoo_manager.getter("signup", superclassCall: super.signup)
            
        }
        
    }
    
    // ["name": "logout", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "AnyObserver<Void>", "isReadOnly": true, "accessibility": ""]
     override var logout: AnyObserver<Void> {
        get {
            
            return cuckoo_manager.getter("logout", superclassCall: super.logout)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_AuthInteractor: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var login: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockAuthInteractor, AnyObserver<Credentials>> {
	        return .init(manager: cuckoo_manager, name: "login")
	    }
	    
	    var signup: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockAuthInteractor, AnyObserver<Credentials>> {
	        return .init(manager: cuckoo_manager, name: "signup")
	    }
	    
	    var logout: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockAuthInteractor, AnyObserver<Void>> {
	        return .init(manager: cuckoo_manager, name: "logout")
	    }
	    
	    
	}

	struct __VerificationProxy_AuthInteractor: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var login: Cuckoo.VerifyReadOnlyProperty<AnyObserver<Credentials>> {
	        return .init(manager: cuckoo_manager, name: "login", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var signup: Cuckoo.VerifyReadOnlyProperty<AnyObserver<Credentials>> {
	        return .init(manager: cuckoo_manager, name: "signup", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var logout: Cuckoo.VerifyReadOnlyProperty<AnyObserver<Void>> {
	        return .init(manager: cuckoo_manager, name: "logout", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class AuthInteractorStub: AuthInteractor {
    
     override var login: AnyObserver<Credentials> {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyObserver<Credentials>).self)
        }
        
    }
    
     override var signup: AnyObserver<Credentials> {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyObserver<Credentials>).self)
        }
        
    }
    
     override var logout: AnyObserver<Void> {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyObserver<Void>).self)
        }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/Auth/AuthPresenter.swift
//
//  AuthPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import Toaster
import Viperit

class MockAuthModuleInterface: AuthModuleInterface, Cuckoo.ProtocolMock {
    typealias MocksType = AuthModuleInterface
    typealias Stubbing = __StubbingProxy_AuthModuleInterface
    typealias Verification = __VerificationProxy_AuthModuleInterface
    let cuckoo_manager = Cuckoo.MockManager(hasParent: false)

    
    // ["name": "successAuth", "stubType": "ProtocolToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Observable<Void>", "isReadOnly": true, "accessibility": ""]
     var successAuth: Observable<Void> {
        get {
            
            return cuckoo_manager.getter("successAuth", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    

    

    
    // ["name": "close", "returnSignature": "", "fullyQualifiedName": "close()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ProtocolStubNoReturnFunction"]
     func close()  {
        
            return cuckoo_manager.call("close()",
                parameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    )
        
    }
    

	struct __StubbingProxy_AuthModuleInterface: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var successAuth: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAuthModuleInterface, Observable<Void>> {
	        return .init(manager: cuckoo_manager, name: "successAuth")
	    }
	    
	    
	    func close() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAuthModuleInterface.self, method: "close()", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_AuthModuleInterface: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var successAuth: Cuckoo.VerifyReadOnlyProperty<Observable<Void>> {
	        return .init(manager: cuckoo_manager, name: "successAuth", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func close() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("close()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class AuthModuleInterfaceStub: AuthModuleInterface {
    
     var successAuth: Observable<Void> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Observable<Void>).self)
        }
        
    }
    

    

    
     func close()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


class MockAuthPresenter: AuthPresenter, Cuckoo.ClassMock {
    typealias MocksType = AuthPresenter
    typealias Stubbing = __StubbingProxy_AuthPresenter
    typealias Verification = __VerificationProxy_AuthPresenter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "successLogin", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "AnyObserver<Void>", "isReadOnly": true, "accessibility": ""]
     override var successLogin: AnyObserver<Void> {
        get {
            
            return cuckoo_manager.getter("successLogin", superclassCall: super.successLogin)
            
        }
        
    }
    
    // ["name": "successSignup", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "AnyObserver<Void>", "isReadOnly": true, "accessibility": ""]
     override var successSignup: AnyObserver<Void> {
        get {
            
            return cuckoo_manager.getter("successSignup", superclassCall: super.successSignup)
            
        }
        
    }
    
    // ["name": "successLogout", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "AnyObserver<Void>", "isReadOnly": true, "accessibility": ""]
     override var successLogout: AnyObserver<Void> {
        get {
            
            return cuckoo_manager.getter("successLogout", superclassCall: super.successLogout)
            
        }
        
    }
    
    // ["name": "errorHandler", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "AnyObserver<String>", "isReadOnly": true, "accessibility": ""]
     override var errorHandler: AnyObserver<String> {
        get {
            
            return cuckoo_manager.getter("errorHandler", superclassCall: super.errorHandler)
            
        }
        
    }
    

    

    
    // ["name": "viewHasLoaded", "returnSignature": "", "fullyQualifiedName": "viewHasLoaded()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func viewHasLoaded()  {
        
            return cuckoo_manager.call("viewHasLoaded()",
                parameters: (),
                superclassCall:
                    
                    super.viewHasLoaded()
                    )
        
    }
    

	struct __StubbingProxy_AuthPresenter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var successLogin: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockAuthPresenter, AnyObserver<Void>> {
	        return .init(manager: cuckoo_manager, name: "successLogin")
	    }
	    
	    var successSignup: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockAuthPresenter, AnyObserver<Void>> {
	        return .init(manager: cuckoo_manager, name: "successSignup")
	    }
	    
	    var successLogout: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockAuthPresenter, AnyObserver<Void>> {
	        return .init(manager: cuckoo_manager, name: "successLogout")
	    }
	    
	    var errorHandler: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockAuthPresenter, AnyObserver<String>> {
	        return .init(manager: cuckoo_manager, name: "errorHandler")
	    }
	    
	    
	    func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAuthPresenter.self, method: "viewHasLoaded()", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_AuthPresenter: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var successLogin: Cuckoo.VerifyReadOnlyProperty<AnyObserver<Void>> {
	        return .init(manager: cuckoo_manager, name: "successLogin", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var successSignup: Cuckoo.VerifyReadOnlyProperty<AnyObserver<Void>> {
	        return .init(manager: cuckoo_manager, name: "successSignup", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var successLogout: Cuckoo.VerifyReadOnlyProperty<AnyObserver<Void>> {
	        return .init(manager: cuckoo_manager, name: "successLogout", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var errorHandler: Cuckoo.VerifyReadOnlyProperty<AnyObserver<String>> {
	        return .init(manager: cuckoo_manager, name: "errorHandler", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func viewHasLoaded() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("viewHasLoaded()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class AuthPresenterStub: AuthPresenter {
    
     override var successLogin: AnyObserver<Void> {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyObserver<Void>).self)
        }
        
    }
    
     override var successSignup: AnyObserver<Void> {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyObserver<Void>).self)
        }
        
    }
    
     override var successLogout: AnyObserver<Void> {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyObserver<Void>).self)
        }
        
    }
    
     override var errorHandler: AnyObserver<String> {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyObserver<String>).self)
        }
        
    }
    

    

    
     override func viewHasLoaded()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/Auth/AuthRouter.swift
//
//  AuthRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit

class MockAuthRouter: AuthRouter, Cuckoo.ClassMock {
    typealias MocksType = AuthRouter
    typealias Stubbing = __StubbingProxy_AuthRouter
    typealias Verification = __VerificationProxy_AuthRouter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "close", "returnSignature": "", "fullyQualifiedName": "close()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func close()  {
        
            return cuckoo_manager.call("close()",
                parameters: (),
                superclassCall:
                    
                    super.close()
                    )
        
    }
    

	struct __StubbingProxy_AuthRouter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAuthRouter.self, method: "close()", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_AuthRouter: Cuckoo.VerificationProxy {
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

 class AuthRouterStub: AuthRouter {
    

    

    
     override func close()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/Categories/CategoriesInteractor.swift
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

class MockCategoriesInteractor: CategoriesInteractor, Cuckoo.ClassMock {
    typealias MocksType = CategoriesInteractor
    typealias Stubbing = __StubbingProxy_CategoriesInteractor
    typealias Verification = __VerificationProxy_CategoriesInteractor
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "configureSubscribers", "returnSignature": "", "fullyQualifiedName": "configureSubscribers()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func configureSubscribers()  {
        
            return cuckoo_manager.call("configureSubscribers()",
                parameters: (),
                superclassCall:
                    
                    super.configureSubscribers()
                    )
        
    }
    
    // ["name": "save", "returnSignature": "", "fullyQualifiedName": "save(category: WBCategory, update: Bool)", "parameterSignature": "category: WBCategory, update: Bool", "parameterSignatureWithoutNames": "category: WBCategory, update: Bool", "inputTypes": "WBCategory, Bool", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "category, update", "call": "category: category, update: update", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("category"), name: "category", type: "WBCategory", range: CountableRange(944..<964), nameRange: CountableRange(944..<952)), CuckooGeneratorFramework.MethodParameter(label: Optional("update"), name: "update", type: "Bool", range: CountableRange(966..<978), nameRange: CountableRange(966..<972))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func save(category: WBCategory, update: Bool)  {
        
            return cuckoo_manager.call("save(category: WBCategory, update: Bool)",
                parameters: (category, update),
                superclassCall:
                    
                    super.save(category: category, update: update)
                    )
        
    }
    
    // ["name": "reorder", "returnSignature": "", "fullyQualifiedName": "reorder(categoryLeft: WBCategory, categoryRight: WBCategory)", "parameterSignature": "categoryLeft: WBCategory, categoryRight: WBCategory", "parameterSignatureWithoutNames": "categoryLeft: WBCategory, categoryRight: WBCategory", "inputTypes": "WBCategory, WBCategory", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "categoryLeft, categoryRight", "call": "categoryLeft: categoryLeft, categoryRight: categoryRight", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("categoryLeft"), name: "categoryLeft", type: "WBCategory", range: CountableRange(1381..<1405), nameRange: CountableRange(1381..<1393)), CuckooGeneratorFramework.MethodParameter(label: Optional("categoryRight"), name: "categoryRight", type: "WBCategory", range: CountableRange(1407..<1432), nameRange: CountableRange(1407..<1420))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func reorder(categoryLeft: WBCategory, categoryRight: WBCategory)  {
        
            return cuckoo_manager.call("reorder(categoryLeft: WBCategory, categoryRight: WBCategory)",
                parameters: (categoryLeft, categoryRight),
                superclassCall:
                    
                    super.reorder(categoryLeft: categoryLeft, categoryRight: categoryRight)
                    )
        
    }
    
    // ["name": "delete", "returnSignature": "", "fullyQualifiedName": "delete(category: WBCategory)", "parameterSignature": "category: WBCategory", "parameterSignatureWithoutNames": "category: WBCategory", "inputTypes": "WBCategory", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "category", "call": "category: category", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("category"), name: "category", type: "WBCategory", range: CountableRange(1540..<1560), nameRange: CountableRange(1540..<1548))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func delete(category: WBCategory)  {
        
            return cuckoo_manager.call("delete(category: WBCategory)",
                parameters: (category),
                superclassCall:
                    
                    super.delete(category: category)
                    )
        
    }
    
    // ["name": "fetchedModelAdapter", "returnSignature": " -> FetchedModelAdapter?", "fullyQualifiedName": "fetchedModelAdapter() -> FetchedModelAdapter?", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Optional<FetchedModelAdapter>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        
            return cuckoo_manager.call("fetchedModelAdapter() -> FetchedModelAdapter?",
                parameters: (),
                superclassCall:
                    
                    super.fetchedModelAdapter()
                    )
        
    }
    

	struct __StubbingProxy_CategoriesInteractor: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func configureSubscribers() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockCategoriesInteractor.self, method: "configureSubscribers()", parameterMatchers: matchers))
	    }
	    
	    func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(category: M1, update: M2) -> Cuckoo.ClassStubNoReturnFunction<(WBCategory, Bool)> where M1.MatchedType == WBCategory, M2.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(WBCategory, Bool)>] = [wrap(matchable: category) { $0.0 }, wrap(matchable: update) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCategoriesInteractor.self, method: "save(category: WBCategory, update: Bool)", parameterMatchers: matchers))
	    }
	    
	    func reorder<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(categoryLeft: M1, categoryRight: M2) -> Cuckoo.ClassStubNoReturnFunction<(WBCategory, WBCategory)> where M1.MatchedType == WBCategory, M2.MatchedType == WBCategory {
	        let matchers: [Cuckoo.ParameterMatcher<(WBCategory, WBCategory)>] = [wrap(matchable: categoryLeft) { $0.0 }, wrap(matchable: categoryRight) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCategoriesInteractor.self, method: "reorder(categoryLeft: WBCategory, categoryRight: WBCategory)", parameterMatchers: matchers))
	    }
	    
	    func delete<M1: Cuckoo.Matchable>(category: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBCategory)> where M1.MatchedType == WBCategory {
	        let matchers: [Cuckoo.ParameterMatcher<(WBCategory)>] = [wrap(matchable: category) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCategoriesInteractor.self, method: "delete(category: WBCategory)", parameterMatchers: matchers))
	    }
	    
	    func fetchedModelAdapter() -> Cuckoo.ClassStubFunction<(), Optional<FetchedModelAdapter>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockCategoriesInteractor.self, method: "fetchedModelAdapter() -> FetchedModelAdapter?", parameterMatchers: matchers))
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
	    func reorder<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(categoryLeft: M1, categoryRight: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == WBCategory, M2.MatchedType == WBCategory {
	        let matchers: [Cuckoo.ParameterMatcher<(WBCategory, WBCategory)>] = [wrap(matchable: categoryLeft) { $0.0 }, wrap(matchable: categoryRight) { $0.1 }]
	        return cuckoo_manager.verify("reorder(categoryLeft: WBCategory, categoryRight: WBCategory)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
    
     override func reorder(categoryLeft: WBCategory, categoryRight: WBCategory)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func delete(category: WBCategory)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        return DefaultValueRegistry.defaultValue(for: Optional<FetchedModelAdapter>.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/Categories/CategoriesPresenter.swift
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

class MockCategoriesPresenter: CategoriesPresenter, Cuckoo.ClassMock {
    typealias MocksType = CategoriesPresenter
    typealias Stubbing = __StubbingProxy_CategoriesPresenter
    typealias Verification = __VerificationProxy_CategoriesPresenter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "viewHasLoaded", "returnSignature": "", "fullyQualifiedName": "viewHasLoaded()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func viewHasLoaded()  {
        
            return cuckoo_manager.call("viewHasLoaded()",
                parameters: (),
                superclassCall:
                    
                    super.viewHasLoaded()
                    )
        
    }
    
    // ["name": "fetchedModelAdapter", "returnSignature": " -> FetchedModelAdapter?", "fullyQualifiedName": "fetchedModelAdapter() -> FetchedModelAdapter?", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Optional<FetchedModelAdapter>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        
            return cuckoo_manager.call("fetchedModelAdapter() -> FetchedModelAdapter?",
                parameters: (),
                superclassCall:
                    
                    super.fetchedModelAdapter()
                    )
        
    }
    

	struct __StubbingProxy_CategoriesPresenter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockCategoriesPresenter.self, method: "viewHasLoaded()", parameterMatchers: matchers))
	    }
	    
	    func fetchedModelAdapter() -> Cuckoo.ClassStubFunction<(), Optional<FetchedModelAdapter>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockCategoriesPresenter.self, method: "fetchedModelAdapter() -> FetchedModelAdapter?", parameterMatchers: matchers))
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
    
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        return DefaultValueRegistry.defaultValue(for: Optional<FetchedModelAdapter>.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/Categories/CategoriesRouter.swift
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

class MockCategoriesRouter: CategoriesRouter, Cuckoo.ClassMock {
    typealias MocksType = CategoriesRouter
    typealias Stubbing = __StubbingProxy_CategoriesRouter
    typealias Verification = __VerificationProxy_CategoriesRouter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    

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


// MARK: - Mocks generated from file: SmartReceipts/Modules/Columns/ColumnsInteractor.swift
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

class MockColumnsInteractor: ColumnsInteractor, Cuckoo.ClassMock {
    typealias MocksType = ColumnsInteractor
    typealias Stubbing = __StubbingProxy_ColumnsInteractor
    typealias Verification = __VerificationProxy_ColumnsInteractor
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "columns", "returnSignature": " -> Observable<[Column]>", "fullyQualifiedName": "columns(forCSV: Bool) -> Observable<[Column]>", "parameterSignature": "forCSV: Bool", "parameterSignatureWithoutNames": "forCSV: Bool", "inputTypes": "Bool", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "forCSV", "call": "forCSV: forCSV", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("forCSV"), name: "forCSV", type: "Bool", range: CountableRange(272..<284), nameRange: CountableRange(272..<278))], "returnType": "Observable<[Column]>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func columns(forCSV: Bool)  -> Observable<[Column]> {
        
            return cuckoo_manager.call("columns(forCSV: Bool) -> Observable<[Column]>",
                parameters: (forCSV),
                superclassCall:
                    
                    super.columns(forCSV: forCSV)
                    )
        
    }
    
    // ["name": "addColumn", "returnSignature": "", "fullyQualifiedName": "addColumn(_: Column, isCSV: Bool)", "parameterSignature": "_ column: Column, isCSV: Bool", "parameterSignatureWithoutNames": "column: Column, isCSV: Bool", "inputTypes": "Column, Bool", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "column, isCSV", "call": "column, isCSV: isCSV", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "column", type: "Column", range: CountableRange(667..<683), nameRange: CountableRange(0..<0)), CuckooGeneratorFramework.MethodParameter(label: Optional("isCSV"), name: "isCSV", type: "Bool", range: CountableRange(685..<696), nameRange: CountableRange(685..<690))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func addColumn(_ column: Column, isCSV: Bool)  {
        
            return cuckoo_manager.call("addColumn(_: Column, isCSV: Bool)",
                parameters: (column, isCSV),
                superclassCall:
                    
                    super.addColumn(column, isCSV: isCSV)
                    )
        
    }
    
    // ["name": "removeColumn", "returnSignature": "", "fullyQualifiedName": "removeColumn(_: Column, isCSV: Bool)", "parameterSignature": "_ column: Column, isCSV: Bool", "parameterSignatureWithoutNames": "column: Column, isCSV: Bool", "inputTypes": "Column, Bool", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "column, isCSV", "call": "column, isCSV: isCSV", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "column", type: "Column", range: CountableRange(1068..<1084), nameRange: CountableRange(0..<0)), CuckooGeneratorFramework.MethodParameter(label: Optional("isCSV"), name: "isCSV", type: "Bool", range: CountableRange(1086..<1097), nameRange: CountableRange(1086..<1091))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func removeColumn(_ column: Column, isCSV: Bool)  {
        
            return cuckoo_manager.call("removeColumn(_: Column, isCSV: Bool)",
                parameters: (column, isCSV),
                superclassCall:
                    
                    super.removeColumn(column, isCSV: isCSV)
                    )
        
    }
    
    // ["name": "reorder", "returnSignature": "", "fullyQualifiedName": "reorder(columnLeft: Column, columnRight: Column, isCSV: Bool)", "parameterSignature": "columnLeft: Column, columnRight: Column, isCSV: Bool", "parameterSignatureWithoutNames": "columnLeft: Column, columnRight: Column, isCSV: Bool", "inputTypes": "Column, Column, Bool", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "columnLeft, columnRight, isCSV", "call": "columnLeft: columnLeft, columnRight: columnRight, isCSV: isCSV", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("columnLeft"), name: "columnLeft", type: "Column", range: CountableRange(1332..<1350), nameRange: CountableRange(1332..<1342)), CuckooGeneratorFramework.MethodParameter(label: Optional("columnRight"), name: "columnRight", type: "Column", range: CountableRange(1352..<1371), nameRange: CountableRange(1352..<1363)), CuckooGeneratorFramework.MethodParameter(label: Optional("isCSV"), name: "isCSV", type: "Bool", range: CountableRange(1373..<1384), nameRange: CountableRange(1373..<1378))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func reorder(columnLeft: Column, columnRight: Column, isCSV: Bool)  {
        
            return cuckoo_manager.call("reorder(columnLeft: Column, columnRight: Column, isCSV: Bool)",
                parameters: (columnLeft, columnRight, isCSV),
                superclassCall:
                    
                    super.reorder(columnLeft: columnLeft, columnRight: columnRight, isCSV: isCSV)
                    )
        
    }
    

	struct __StubbingProxy_ColumnsInteractor: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func columns<M1: Cuckoo.Matchable>(forCSV: M1) -> Cuckoo.ClassStubFunction<(Bool), Observable<[Column]>> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: forCSV) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockColumnsInteractor.self, method: "columns(forCSV: Bool) -> Observable<[Column]>", parameterMatchers: matchers))
	    }
	    
	    func addColumn<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ column: M1, isCSV: M2) -> Cuckoo.ClassStubNoReturnFunction<(Column, Bool)> where M1.MatchedType == Column, M2.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Column, Bool)>] = [wrap(matchable: column) { $0.0 }, wrap(matchable: isCSV) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockColumnsInteractor.self, method: "addColumn(_: Column, isCSV: Bool)", parameterMatchers: matchers))
	    }
	    
	    func removeColumn<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ column: M1, isCSV: M2) -> Cuckoo.ClassStubNoReturnFunction<(Column, Bool)> where M1.MatchedType == Column, M2.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Column, Bool)>] = [wrap(matchable: column) { $0.0 }, wrap(matchable: isCSV) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockColumnsInteractor.self, method: "removeColumn(_: Column, isCSV: Bool)", parameterMatchers: matchers))
	    }
	    
	    func reorder<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(columnLeft: M1, columnRight: M2, isCSV: M3) -> Cuckoo.ClassStubNoReturnFunction<(Column, Column, Bool)> where M1.MatchedType == Column, M2.MatchedType == Column, M3.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Column, Column, Bool)>] = [wrap(matchable: columnLeft) { $0.0 }, wrap(matchable: columnRight) { $0.1 }, wrap(matchable: isCSV) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockColumnsInteractor.self, method: "reorder(columnLeft: Column, columnRight: Column, isCSV: Bool)", parameterMatchers: matchers))
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
	    func addColumn<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ column: M1, isCSV: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Column, M2.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Column, Bool)>] = [wrap(matchable: column) { $0.0 }, wrap(matchable: isCSV) { $0.1 }]
	        return cuckoo_manager.verify("addColumn(_: Column, isCSV: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func removeColumn<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ column: M1, isCSV: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Column, M2.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Column, Bool)>] = [wrap(matchable: column) { $0.0 }, wrap(matchable: isCSV) { $0.1 }]
	        return cuckoo_manager.verify("removeColumn(_: Column, isCSV: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func reorder<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(columnLeft: M1, columnRight: M2, isCSV: M3) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Column, M2.MatchedType == Column, M3.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Column, Column, Bool)>] = [wrap(matchable: columnLeft) { $0.0 }, wrap(matchable: columnRight) { $0.1 }, wrap(matchable: isCSV) { $0.2 }]
	        return cuckoo_manager.verify("reorder(columnLeft: Column, columnRight: Column, isCSV: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class ColumnsInteractorStub: ColumnsInteractor {
    

    

    
     override func columns(forCSV: Bool)  -> Observable<[Column]> {
        return DefaultValueRegistry.defaultValue(for: Observable<[Column]>.self)
    }
    
     override func addColumn(_ column: Column, isCSV: Bool)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func removeColumn(_ column: Column, isCSV: Bool)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func reorder(columnLeft: Column, columnRight: Column, isCSV: Bool)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/Columns/ColumnsPresenter.swift
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

class MockColumnsPresenter: ColumnsPresenter, Cuckoo.ClassMock {
    typealias MocksType = ColumnsPresenter
    typealias Stubbing = __StubbingProxy_ColumnsPresenter
    typealias Verification = __VerificationProxy_ColumnsPresenter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "setupView", "returnSignature": "", "fullyQualifiedName": "setupView(data: Any)", "parameterSignature": "data: Any", "parameterSignatureWithoutNames": "data: Any", "inputTypes": "Any", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "data", "call": "data: data", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("data"), name: "data", type: "Any", range: CountableRange(504..<513), nameRange: CountableRange(504..<508))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func setupView(data: Any)  {
        
            return cuckoo_manager.call("setupView(data: Any)",
                parameters: (data),
                superclassCall:
                    
                    super.setupView(data: data)
                    )
        
    }
    
    // ["name": "viewHasLoaded", "returnSignature": "", "fullyQualifiedName": "viewHasLoaded()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func viewHasLoaded()  {
        
            return cuckoo_manager.call("viewHasLoaded()",
                parameters: (),
                superclassCall:
                    
                    super.viewHasLoaded()
                    )
        
    }
    
    // ["name": "nextObjectID", "returnSignature": " -> Int", "fullyQualifiedName": "nextObjectID() -> Int", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Int", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func nextObjectID()  -> Int {
        
            return cuckoo_manager.call("nextObjectID() -> Int",
                parameters: (),
                superclassCall:
                    
                    super.nextObjectID()
                    )
        
    }
    
    // ["name": "updateData", "returnSignature": "", "fullyQualifiedName": "updateData()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func updateData()  {
        
            return cuckoo_manager.call("updateData()",
                parameters: (),
                superclassCall:
                    
                    super.updateData()
                    )
        
    }
    

	struct __StubbingProxy_ColumnsPresenter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.ClassStubNoReturnFunction<(Any)> where M1.MatchedType == Any {
	        let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockColumnsPresenter.self, method: "setupView(data: Any)", parameterMatchers: matchers))
	    }
	    
	    func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockColumnsPresenter.self, method: "viewHasLoaded()", parameterMatchers: matchers))
	    }
	    
	    func nextObjectID() -> Cuckoo.ClassStubFunction<(), Int> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockColumnsPresenter.self, method: "nextObjectID() -> Int", parameterMatchers: matchers))
	    }
	    
	    func updateData() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockColumnsPresenter.self, method: "updateData()", parameterMatchers: matchers))
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
	    func viewHasLoaded() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("viewHasLoaded()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func nextObjectID() -> Cuckoo.__DoNotUse<Int> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("nextObjectID() -> Int", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func updateData() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("updateData()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class ColumnsPresenterStub: ColumnsPresenter {
    

    

    
     override func setupView(data: Any)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func viewHasLoaded()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func nextObjectID()  -> Int {
        return DefaultValueRegistry.defaultValue(for: Int.self)
    }
    
     override func updateData()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/Columns/ColumnsRouter.swift
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

class MockColumnsRouter: ColumnsRouter, Cuckoo.ClassMock {
    typealias MocksType = ColumnsRouter
    typealias Stubbing = __StubbingProxy_ColumnsRouter
    typealias Verification = __VerificationProxy_ColumnsRouter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    

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


// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Distance/EditDistanceInteractor.swift
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
import Toaster
import Viperit

class MockEditDistanceInteractor: EditDistanceInteractor, Cuckoo.ClassMock {
    typealias MocksType = EditDistanceInteractor
    typealias Stubbing = __StubbingProxy_EditDistanceInteractor
    typealias Verification = __VerificationProxy_EditDistanceInteractor
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "save", "returnSignature": "", "fullyQualifiedName": "save(distance: Distance, asNewDistance: Bool)", "parameterSignature": "distance: Distance, asNewDistance: Bool", "parameterSignatureWithoutNames": "distance: Distance, asNewDistance: Bool", "inputTypes": "Distance, Bool", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "distance, asNewDistance", "call": "distance: distance, asNewDistance: asNewDistance", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("distance"), name: "distance", type: "Distance", range: CountableRange(519..<537), nameRange: CountableRange(519..<527)), CuckooGeneratorFramework.MethodParameter(label: Optional("asNewDistance"), name: "asNewDistance", type: "Bool", range: CountableRange(539..<558), nameRange: CountableRange(539..<552))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func save(distance: Distance, asNewDistance: Bool)  {
        
            return cuckoo_manager.call("save(distance: Distance, asNewDistance: Bool)",
                parameters: (distance, asNewDistance),
                superclassCall:
                    
                    super.save(distance: distance, asNewDistance: asNewDistance)
                    )
        
    }
    

	struct __StubbingProxy_EditDistanceInteractor: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(distance: M1, asNewDistance: M2) -> Cuckoo.ClassStubNoReturnFunction<(Distance, Bool)> where M1.MatchedType == Distance, M2.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Distance, Bool)>] = [wrap(matchable: distance) { $0.0 }, wrap(matchable: asNewDistance) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockEditDistanceInteractor.self, method: "save(distance: Distance, asNewDistance: Bool)", parameterMatchers: matchers))
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


// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Distance/EditDistancePresenter.swift
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

class MockEditDistancePresenter: EditDistancePresenter, Cuckoo.ClassMock {
    typealias MocksType = EditDistancePresenter
    typealias Stubbing = __StubbingProxy_EditDistancePresenter
    typealias Verification = __VerificationProxy_EditDistancePresenter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "setupView", "returnSignature": "", "fullyQualifiedName": "setupView(data: Any)", "parameterSignature": "data: Any", "parameterSignatureWithoutNames": "data: Any", "inputTypes": "Any", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "data", "call": "data: data", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("data"), name: "data", type: "Any", range: CountableRange(265..<274), nameRange: CountableRange(265..<269))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func setupView(data: Any)  {
        
            return cuckoo_manager.call("setupView(data: Any)",
                parameters: (data),
                superclassCall:
                    
                    super.setupView(data: data)
                    )
        
    }
    
    // ["name": "save", "returnSignature": "", "fullyQualifiedName": "save(distance: Distance, asNewDistance: Bool)", "parameterSignature": "distance: Distance, asNewDistance: Bool", "parameterSignatureWithoutNames": "distance: Distance, asNewDistance: Bool", "inputTypes": "Distance, Bool", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "distance, asNewDistance", "call": "distance: distance, asNewDistance: asNewDistance", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("distance"), name: "distance", type: "Distance", range: CountableRange(462..<480), nameRange: CountableRange(462..<470)), CuckooGeneratorFramework.MethodParameter(label: Optional("asNewDistance"), name: "asNewDistance", type: "Bool", range: CountableRange(482..<501), nameRange: CountableRange(482..<495))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func save(distance: Distance, asNewDistance: Bool)  {
        
            return cuckoo_manager.call("save(distance: Distance, asNewDistance: Bool)",
                parameters: (distance, asNewDistance),
                superclassCall:
                    
                    super.save(distance: distance, asNewDistance: asNewDistance)
                    )
        
    }
    
    // ["name": "close", "returnSignature": "", "fullyQualifiedName": "close()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func close()  {
        
            return cuckoo_manager.call("close()",
                parameters: (),
                superclassCall:
                    
                    super.close()
                    )
        
    }
    

	struct __StubbingProxy_EditDistancePresenter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.ClassStubNoReturnFunction<(Any)> where M1.MatchedType == Any {
	        let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockEditDistancePresenter.self, method: "setupView(data: Any)", parameterMatchers: matchers))
	    }
	    
	    func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(distance: M1, asNewDistance: M2) -> Cuckoo.ClassStubNoReturnFunction<(Distance, Bool)> where M1.MatchedType == Distance, M2.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Distance, Bool)>] = [wrap(matchable: distance) { $0.0 }, wrap(matchable: asNewDistance) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockEditDistancePresenter.self, method: "save(distance: Distance, asNewDistance: Bool)", parameterMatchers: matchers))
	    }
	    
	    func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEditDistancePresenter.self, method: "close()", parameterMatchers: matchers))
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


// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Distance/EditDistanceRouter.swift
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

class MockEditDistanceRouter: EditDistanceRouter, Cuckoo.ClassMock {
    typealias MocksType = EditDistanceRouter
    typealias Stubbing = __StubbingProxy_EditDistanceRouter
    typealias Verification = __VerificationProxy_EditDistanceRouter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "close", "returnSignature": "", "fullyQualifiedName": "close()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func close()  {
        
            return cuckoo_manager.call("close()",
                parameters: (),
                superclassCall:
                    
                    super.close()
                    )
        
    }
    

	struct __StubbingProxy_EditDistanceRouter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEditDistanceRouter.self, method: "close()", parameterMatchers: matchers))
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


// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Receipt/EditReceiptInteractor.swift
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
import Toaster
import Viperit

class MockEditReceiptInteractor: EditReceiptInteractor, Cuckoo.ClassMock {
    typealias MocksType = EditReceiptInteractor
    typealias Stubbing = __StubbingProxy_EditReceiptInteractor
    typealias Verification = __VerificationProxy_EditReceiptInteractor
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "receiptFilePath", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "URL?", "isReadOnly": false, "accessibility": ""]
     override var receiptFilePath: URL? {
        get {
            
            return cuckoo_manager.getter("receiptFilePath", superclassCall: super.receiptFilePath)
            
        }
        
        set {
            
            cuckoo_manager.setter("receiptFilePath", value: newValue, superclassCall: super.receiptFilePath = newValue)
            
        }
        
    }
    

    

    
    // ["name": "configureSubscribers", "returnSignature": "", "fullyQualifiedName": "configureSubscribers()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func configureSubscribers()  {
        
            return cuckoo_manager.call("configureSubscribers()",
                parameters: (),
                superclassCall:
                    
                    super.configureSubscribers()
                    )
        
    }
    
    // ["name": "tooltipText", "returnSignature": " -> String?", "fullyQualifiedName": "tooltipText() -> String?", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Optional<String>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func tooltipText()  -> String? {
        
            return cuckoo_manager.call("tooltipText() -> String?",
                parameters: (),
                superclassCall:
                    
                    super.tooltipText()
                    )
        
    }
    

	struct __StubbingProxy_EditReceiptInteractor: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var receiptFilePath: Cuckoo.ClassToBeStubbedProperty<MockEditReceiptInteractor, URL?> {
	        return .init(manager: cuckoo_manager, name: "receiptFilePath")
	    }
	    
	    
	    func configureSubscribers() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptInteractor.self, method: "configureSubscribers()", parameterMatchers: matchers))
	    }
	    
	    func tooltipText() -> Cuckoo.ClassStubFunction<(), Optional<String>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptInteractor.self, method: "tooltipText() -> String?", parameterMatchers: matchers))
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
	
	    
	    var receiptFilePath: Cuckoo.VerifyProperty<URL?> {
	        return .init(manager: cuckoo_manager, name: "receiptFilePath", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func configureSubscribers() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("configureSubscribers()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func tooltipText() -> Cuckoo.__DoNotUse<Optional<String>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("tooltipText() -> String?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class EditReceiptInteractorStub: EditReceiptInteractor {
    
     override var receiptFilePath: URL? {
        get {
            return DefaultValueRegistry.defaultValue(for: (URL?).self)
        }
        
        set { }
        
    }
    

    

    
     override func configureSubscribers()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func tooltipText()  -> String? {
        return DefaultValueRegistry.defaultValue(for: Optional<String>.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Receipt/EditReceiptPresenter.swift
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
import UserNotifications
import Viperit

class MockEditReceiptModuleInterface: EditReceiptModuleInterface, Cuckoo.ProtocolMock {
    typealias MocksType = EditReceiptModuleInterface
    typealias Stubbing = __StubbingProxy_EditReceiptModuleInterface
    typealias Verification = __VerificationProxy_EditReceiptModuleInterface
    let cuckoo_manager = Cuckoo.MockManager(hasParent: false)

    
    // ["name": "removeAction", "stubType": "ProtocolToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Observable<WBReceipt>", "isReadOnly": true, "accessibility": ""]
     var removeAction: Observable<WBReceipt> {
        get {
            
            return cuckoo_manager.getter("removeAction", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    
    // ["name": "showAttachmentAction", "stubType": "ProtocolToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Observable<WBReceipt>", "isReadOnly": true, "accessibility": ""]
     var showAttachmentAction: Observable<WBReceipt> {
        get {
            
            return cuckoo_manager.getter("showAttachmentAction", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    

    

    
    // ["name": "disableFirstResponder", "returnSignature": "", "fullyQualifiedName": "disableFirstResponder()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ProtocolStubNoReturnFunction"]
     func disableFirstResponder()  {
        
            return cuckoo_manager.call("disableFirstResponder()",
                parameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    )
        
    }
    
    // ["name": "makeNameFirstResponder", "returnSignature": "", "fullyQualifiedName": "makeNameFirstResponder()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ProtocolStubNoReturnFunction"]
     func makeNameFirstResponder()  {
        
            return cuckoo_manager.call("makeNameFirstResponder()",
                parameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    )
        
    }
    

	struct __StubbingProxy_EditReceiptModuleInterface: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var removeAction: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockEditReceiptModuleInterface, Observable<WBReceipt>> {
	        return .init(manager: cuckoo_manager, name: "removeAction")
	    }
	    
	    var showAttachmentAction: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockEditReceiptModuleInterface, Observable<WBReceipt>> {
	        return .init(manager: cuckoo_manager, name: "showAttachmentAction")
	    }
	    
	    
	    func disableFirstResponder() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptModuleInterface.self, method: "disableFirstResponder()", parameterMatchers: matchers))
	    }
	    
	    func makeNameFirstResponder() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptModuleInterface.self, method: "makeNameFirstResponder()", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_EditReceiptModuleInterface: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var removeAction: Cuckoo.VerifyReadOnlyProperty<Observable<WBReceipt>> {
	        return .init(manager: cuckoo_manager, name: "removeAction", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var showAttachmentAction: Cuckoo.VerifyReadOnlyProperty<Observable<WBReceipt>> {
	        return .init(manager: cuckoo_manager, name: "showAttachmentAction", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func disableFirstResponder() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("disableFirstResponder()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func makeNameFirstResponder() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("makeNameFirstResponder()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class EditReceiptModuleInterfaceStub: EditReceiptModuleInterface {
    
     var removeAction: Observable<WBReceipt> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Observable<WBReceipt>).self)
        }
        
    }
    
     var showAttachmentAction: Observable<WBReceipt> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Observable<WBReceipt>).self)
        }
        
    }
    

    

    
     func disableFirstResponder()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func makeNameFirstResponder()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


class MockEditReceiptPresenter: EditReceiptPresenter, Cuckoo.ClassMock {
    typealias MocksType = EditReceiptPresenter
    typealias Stubbing = __StubbingProxy_EditReceiptPresenter
    typealias Verification = __VerificationProxy_EditReceiptPresenter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "viewHasLoaded", "returnSignature": "", "fullyQualifiedName": "viewHasLoaded()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func viewHasLoaded()  {
        
            return cuckoo_manager.call("viewHasLoaded()",
                parameters: (),
                superclassCall:
                    
                    super.viewHasLoaded()
                    )
        
    }
    
    // ["name": "setupView", "returnSignature": "", "fullyQualifiedName": "setupView(data: Any)", "parameterSignature": "data: Any", "parameterSignatureWithoutNames": "data: Any", "inputTypes": "Any", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "data", "call": "data: data", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("data"), name: "data", type: "Any", range: CountableRange(2637..<2646), nameRange: CountableRange(2637..<2641))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func setupView(data: Any)  {
        
            return cuckoo_manager.call("setupView(data: Any)",
                parameters: (data),
                superclassCall:
                    
                    super.setupView(data: data)
                    )
        
    }
    
    // ["name": "close", "returnSignature": "", "fullyQualifiedName": "close()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func close()  {
        
            return cuckoo_manager.call("close()",
                parameters: (),
                superclassCall:
                    
                    super.close()
                    )
        
    }
    
    // ["name": "present", "returnSignature": "", "fullyQualifiedName": "present(errorDescription: String)", "parameterSignature": "errorDescription: String", "parameterSignatureWithoutNames": "errorDescription: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "errorDescription", "call": "errorDescription: errorDescription", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("errorDescription"), name: "errorDescription", type: "String", range: CountableRange(3137..<3161), nameRange: CountableRange(3137..<3153))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func present(errorDescription: String)  {
        
            return cuckoo_manager.call("present(errorDescription: String)",
                parameters: (errorDescription),
                superclassCall:
                    
                    super.present(errorDescription: errorDescription)
                    )
        
    }
    
    // ["name": "tooltipText", "returnSignature": " -> String?", "fullyQualifiedName": "tooltipText() -> String?", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Optional<String>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func tooltipText()  -> String? {
        
            return cuckoo_manager.call("tooltipText() -> String?",
                parameters: (),
                superclassCall:
                    
                    super.tooltipText()
                    )
        
    }
    

	struct __StubbingProxy_EditReceiptPresenter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptPresenter.self, method: "viewHasLoaded()", parameterMatchers: matchers))
	    }
	    
	    func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.ClassStubNoReturnFunction<(Any)> where M1.MatchedType == Any {
	        let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptPresenter.self, method: "setupView(data: Any)", parameterMatchers: matchers))
	    }
	    
	    func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptPresenter.self, method: "close()", parameterMatchers: matchers))
	    }
	    
	    func present<M1: Cuckoo.Matchable>(errorDescription: M1) -> Cuckoo.ClassStubNoReturnFunction<(String)> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: errorDescription) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptPresenter.self, method: "present(errorDescription: String)", parameterMatchers: matchers))
	    }
	    
	    func tooltipText() -> Cuckoo.ClassStubFunction<(), Optional<String>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptPresenter.self, method: "tooltipText() -> String?", parameterMatchers: matchers))
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
	    
	    @discardableResult
	    func tooltipText() -> Cuckoo.__DoNotUse<Optional<String>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("tooltipText() -> String?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
    
     override func tooltipText()  -> String? {
        return DefaultValueRegistry.defaultValue(for: Optional<String>.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Receipt/EditReceiptRouter.swift
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

class MockEditReceiptRouter: EditReceiptRouter, Cuckoo.ClassMock {
    typealias MocksType = EditReceiptRouter
    typealias Stubbing = __StubbingProxy_EditReceiptRouter
    typealias Verification = __VerificationProxy_EditReceiptRouter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "openSettings", "returnSignature": "", "fullyQualifiedName": "openSettings()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openSettings()  {
        
            return cuckoo_manager.call("openSettings()",
                parameters: (),
                superclassCall:
                    
                    super.openSettings()
                    )
        
    }
    
    // ["name": "close", "returnSignature": "", "fullyQualifiedName": "close()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func close()  {
        
            return cuckoo_manager.call("close()",
                parameters: (),
                superclassCall:
                    
                    super.close()
                    )
        
    }
    
    // ["name": "openAuth", "returnSignature": " -> AuthModuleInterface", "fullyQualifiedName": "openAuth() -> AuthModuleInterface", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "AuthModuleInterface", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func openAuth()  -> AuthModuleInterface {
        
            return cuckoo_manager.call("openAuth() -> AuthModuleInterface",
                parameters: (),
                superclassCall:
                    
                    super.openAuth()
                    )
        
    }
    
    // ["name": "openAutoScans", "returnSignature": "", "fullyQualifiedName": "openAutoScans()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openAutoScans()  {
        
            return cuckoo_manager.call("openAutoScans()",
                parameters: (),
                superclassCall:
                    
                    super.openAutoScans()
                    )
        
    }
    
    // ["name": "openPaymentMethods", "returnSignature": "", "fullyQualifiedName": "openPaymentMethods()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openPaymentMethods()  {
        
            return cuckoo_manager.call("openPaymentMethods()",
                parameters: (),
                superclassCall:
                    
                    super.openPaymentMethods()
                    )
        
    }
    
    // ["name": "openCategories", "returnSignature": "", "fullyQualifiedName": "openCategories()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openCategories()  {
        
            return cuckoo_manager.call("openCategories()",
                parameters: (),
                superclassCall:
                    
                    super.openCategories()
                    )
        
    }
    

	struct __StubbingProxy_EditReceiptRouter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func openSettings() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptRouter.self, method: "openSettings()", parameterMatchers: matchers))
	    }
	    
	    func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptRouter.self, method: "close()", parameterMatchers: matchers))
	    }
	    
	    func openAuth() -> Cuckoo.ClassStubFunction<(), AuthModuleInterface> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptRouter.self, method: "openAuth() -> AuthModuleInterface", parameterMatchers: matchers))
	    }
	    
	    func openAutoScans() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptRouter.self, method: "openAutoScans()", parameterMatchers: matchers))
	    }
	    
	    func openPaymentMethods() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptRouter.self, method: "openPaymentMethods()", parameterMatchers: matchers))
	    }
	    
	    func openCategories() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEditReceiptRouter.self, method: "openCategories()", parameterMatchers: matchers))
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
	    
	    @discardableResult
	    func openAuth() -> Cuckoo.__DoNotUse<AuthModuleInterface> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("openAuth() -> AuthModuleInterface", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func openAutoScans() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("openAutoScans()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func openPaymentMethods() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("openPaymentMethods()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func openCategories() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("openCategories()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
    
     override func openAuth()  -> AuthModuleInterface {
        return DefaultValueRegistry.defaultValue(for: AuthModuleInterface.self)
    }
    
     override func openAutoScans()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openPaymentMethods()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openCategories()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Trip/EditTripInteractor.swift
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

class MockEditTripInteractor: EditTripInteractor, Cuckoo.ClassMock {
    typealias MocksType = EditTripInteractor
    typealias Stubbing = __StubbingProxy_EditTripInteractor
    typealias Verification = __VerificationProxy_EditTripInteractor
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "configureSubscribers", "returnSignature": "", "fullyQualifiedName": "configureSubscribers()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func configureSubscribers()  {
        
            return cuckoo_manager.call("configureSubscribers()",
                parameters: (),
                superclassCall:
                    
                    super.configureSubscribers()
                    )
        
    }
    
    // ["name": "save", "returnSignature": "", "fullyQualifiedName": "save(trip: WBTrip, update: Bool)", "parameterSignature": "trip: WBTrip, update: Bool", "parameterSignatureWithoutNames": "trip: WBTrip, update: Bool", "inputTypes": "WBTrip, Bool", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "trip, update", "call": "trip: trip, update: update", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("trip"), name: "trip", type: "WBTrip", range: CountableRange(758..<770), nameRange: CountableRange(758..<762)), CuckooGeneratorFramework.MethodParameter(label: Optional("update"), name: "update", type: "Bool", range: CountableRange(772..<792), nameRange: CountableRange(772..<778))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func save(trip: WBTrip, update: Bool)  {
        
            return cuckoo_manager.call("save(trip: WBTrip, update: Bool)",
                parameters: (trip, update),
                superclassCall:
                    
                    super.save(trip: trip, update: update)
                    )
        
    }
    

	struct __StubbingProxy_EditTripInteractor: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func configureSubscribers() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEditTripInteractor.self, method: "configureSubscribers()", parameterMatchers: matchers))
	    }
	    
	    func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(trip: M1, update: M2) -> Cuckoo.ClassStubNoReturnFunction<(WBTrip, Bool)> where M1.MatchedType == WBTrip, M2.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(WBTrip, Bool)>] = [wrap(matchable: trip) { $0.0 }, wrap(matchable: update) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockEditTripInteractor.self, method: "save(trip: WBTrip, update: Bool)", parameterMatchers: matchers))
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


// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Trip/EditTripPresenter.swift
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

class MockEditTripPresenter: EditTripPresenter, Cuckoo.ClassMock {
    typealias MocksType = EditTripPresenter
    typealias Stubbing = __StubbingProxy_EditTripPresenter
    typealias Verification = __VerificationProxy_EditTripPresenter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "viewHasLoaded", "returnSignature": "", "fullyQualifiedName": "viewHasLoaded()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func viewHasLoaded()  {
        
            return cuckoo_manager.call("viewHasLoaded()",
                parameters: (),
                superclassCall:
                    
                    super.viewHasLoaded()
                    )
        
    }
    
    // ["name": "setupView", "returnSignature": "", "fullyQualifiedName": "setupView(data: Any)", "parameterSignature": "data: Any", "parameterSignatureWithoutNames": "data: Any", "inputTypes": "Any", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "data", "call": "data: data", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("data"), name: "data", type: "Any", range: CountableRange(469..<478), nameRange: CountableRange(469..<473))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func setupView(data: Any)  {
        
            return cuckoo_manager.call("setupView(data: Any)",
                parameters: (data),
                superclassCall:
                    
                    super.setupView(data: data)
                    )
        
    }
    
    // ["name": "close", "returnSignature": "", "fullyQualifiedName": "close()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func close()  {
        
            return cuckoo_manager.call("close()",
                parameters: (),
                superclassCall:
                    
                    super.close()
                    )
        
    }
    

	struct __StubbingProxy_EditTripPresenter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEditTripPresenter.self, method: "viewHasLoaded()", parameterMatchers: matchers))
	    }
	    
	    func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.ClassStubNoReturnFunction<(Any)> where M1.MatchedType == Any {
	        let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockEditTripPresenter.self, method: "setupView(data: Any)", parameterMatchers: matchers))
	    }
	    
	    func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEditTripPresenter.self, method: "close()", parameterMatchers: matchers))
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
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/Edit Trip/EditTripRouter.swift
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

class MockEditTripRouter: EditTripRouter, Cuckoo.ClassMock {
    typealias MocksType = EditTripRouter
    typealias Stubbing = __StubbingProxy_EditTripRouter
    typealias Verification = __VerificationProxy_EditTripRouter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "close", "returnSignature": "", "fullyQualifiedName": "close()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func close()  {
        
            return cuckoo_manager.call("close()",
                parameters: (),
                superclassCall:
                    
                    super.close()
                    )
        
    }
    

	struct __StubbingProxy_EditTripRouter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockEditTripRouter.self, method: "close()", parameterMatchers: matchers))
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


// MARK: - Mocks generated from file: SmartReceipts/Modules/Generate Report/GenerateReportInteractor.swift
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
import Toaster
import Viperit

class MockGenerateReportInteractor: GenerateReportInteractor, Cuckoo.ClassMock {
    typealias MocksType = GenerateReportInteractor
    typealias Stubbing = __StubbingProxy_GenerateReportInteractor
    typealias Verification = __VerificationProxy_GenerateReportInteractor
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "generator", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "ReportAssetsGenerator?", "isReadOnly": false, "accessibility": ""]
     override var generator: ReportAssetsGenerator? {
        get {
            
            return cuckoo_manager.getter("generator", superclassCall: super.generator)
            
        }
        
        set {
            
            cuckoo_manager.setter("generator", value: newValue, superclassCall: super.generator = newValue)
            
        }
        
    }
    
    // ["name": "shareService", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "GenerateReportShareService?", "isReadOnly": false, "accessibility": ""]
     override var shareService: GenerateReportShareService? {
        get {
            
            return cuckoo_manager.getter("shareService", superclassCall: super.shareService)
            
        }
        
        set {
            
            cuckoo_manager.setter("shareService", value: newValue, superclassCall: super.shareService = newValue)
            
        }
        
    }
    
    // ["name": "trip", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "WBTrip!", "isReadOnly": false, "accessibility": ""]
     override var trip: WBTrip! {
        get {
            
            return cuckoo_manager.getter("trip", superclassCall: super.trip)
            
        }
        
        set {
            
            cuckoo_manager.setter("trip", value: newValue, superclassCall: super.trip = newValue)
            
        }
        
    }
    
    // ["name": "titleSubtitle", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "TitleSubtitle", "isReadOnly": true, "accessibility": ""]
     override var titleSubtitle: TitleSubtitle {
        get {
            
            return cuckoo_manager.getter("titleSubtitle", superclassCall: super.titleSubtitle)
            
        }
        
    }
    

    

    
    // ["name": "configure", "returnSignature": "", "fullyQualifiedName": "configure(with: WBTrip)", "parameterSignature": "with trip: WBTrip", "parameterSignatureWithoutNames": "trip: WBTrip", "inputTypes": "WBTrip", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "trip", "call": "with: trip", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("with"), name: "trip", type: "WBTrip", range: CountableRange(904..<921), nameRange: CountableRange(904..<908))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func configure(with trip: WBTrip)  {
        
            return cuckoo_manager.call("configure(with: WBTrip)",
                parameters: (trip),
                superclassCall:
                    
                    super.configure(with: trip)
                    )
        
    }
    
    // ["name": "configureBinding", "returnSignature": "", "fullyQualifiedName": "configureBinding()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func configureBinding()  {
        
            return cuckoo_manager.call("configureBinding()",
                parameters: (),
                superclassCall:
                    
                    super.configureBinding()
                    )
        
    }
    
    // ["name": "trackConfigureReportEvent", "returnSignature": "", "fullyQualifiedName": "trackConfigureReportEvent()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func trackConfigureReportEvent()  {
        
            return cuckoo_manager.call("trackConfigureReportEvent()",
                parameters: (),
                superclassCall:
                    
                    super.trackConfigureReportEvent()
                    )
        
    }
    
    // ["name": "trackGeneratorEvents", "returnSignature": "", "fullyQualifiedName": "trackGeneratorEvents()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func trackGeneratorEvents()  {
        
            return cuckoo_manager.call("trackGeneratorEvents()",
                parameters: (),
                superclassCall:
                    
                    super.trackGeneratorEvents()
                    )
        
    }
    
    // ["name": "generateReport", "returnSignature": "", "fullyQualifiedName": "generateReport()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func generateReport()  {
        
            return cuckoo_manager.call("generateReport()",
                parameters: (),
                superclassCall:
                    
                    super.generateReport()
                    )
        
    }
    
    // ["name": "validateSelection", "returnSignature": " -> Bool", "fullyQualifiedName": "validateSelection() -> Bool", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Bool", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func validateSelection()  -> Bool {
        
            return cuckoo_manager.call("validateSelection() -> Bool",
                parameters: (),
                superclassCall:
                    
                    super.validateSelection()
                    )
        
    }
    

	struct __StubbingProxy_GenerateReportInteractor: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var generator: Cuckoo.ClassToBeStubbedProperty<MockGenerateReportInteractor, ReportAssetsGenerator?> {
	        return .init(manager: cuckoo_manager, name: "generator")
	    }
	    
	    var shareService: Cuckoo.ClassToBeStubbedProperty<MockGenerateReportInteractor, GenerateReportShareService?> {
	        return .init(manager: cuckoo_manager, name: "shareService")
	    }
	    
	    var trip: Cuckoo.ClassToBeStubbedProperty<MockGenerateReportInteractor, WBTrip?> {
	        return .init(manager: cuckoo_manager, name: "trip")
	    }
	    
	    var titleSubtitle: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockGenerateReportInteractor, TitleSubtitle> {
	        return .init(manager: cuckoo_manager, name: "titleSubtitle")
	    }
	    
	    
	    func configure<M1: Cuckoo.Matchable>(with trip: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBTrip)> where M1.MatchedType == WBTrip {
	        let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportInteractor.self, method: "configure(with: WBTrip)", parameterMatchers: matchers))
	    }
	    
	    func configureBinding() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportInteractor.self, method: "configureBinding()", parameterMatchers: matchers))
	    }
	    
	    func trackConfigureReportEvent() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportInteractor.self, method: "trackConfigureReportEvent()", parameterMatchers: matchers))
	    }
	    
	    func trackGeneratorEvents() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportInteractor.self, method: "trackGeneratorEvents()", parameterMatchers: matchers))
	    }
	    
	    func generateReport() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportInteractor.self, method: "generateReport()", parameterMatchers: matchers))
	    }
	    
	    func validateSelection() -> Cuckoo.ClassStubFunction<(), Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportInteractor.self, method: "validateSelection() -> Bool", parameterMatchers: matchers))
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
	    
	    var trip: Cuckoo.VerifyProperty<WBTrip?> {
	        return .init(manager: cuckoo_manager, name: "trip", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var titleSubtitle: Cuckoo.VerifyReadOnlyProperty<TitleSubtitle> {
	        return .init(manager: cuckoo_manager, name: "titleSubtitle", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func configure<M1: Cuckoo.Matchable>(with trip: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == WBTrip {
	        let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
	        return cuckoo_manager.verify("configure(with: WBTrip)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
    
     override var trip: WBTrip! {
        get {
            return DefaultValueRegistry.defaultValue(for: (WBTrip!).self)
        }
        
        set { }
        
    }
    
     override var titleSubtitle: TitleSubtitle {
        get {
            return DefaultValueRegistry.defaultValue(for: (TitleSubtitle).self)
        }
        
    }
    

    

    
     override func configure(with trip: WBTrip)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
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


// MARK: - Mocks generated from file: SmartReceipts/Modules/Generate Report/GenerateReportPresenter.swift
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

class MockGenerateReportPresenter: GenerateReportPresenter, Cuckoo.ClassMock {
    typealias MocksType = GenerateReportPresenter
    typealias Stubbing = __StubbingProxy_GenerateReportPresenter
    typealias Verification = __VerificationProxy_GenerateReportPresenter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "viewHasLoaded", "returnSignature": "", "fullyQualifiedName": "viewHasLoaded()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func viewHasLoaded()  {
        
            return cuckoo_manager.call("viewHasLoaded()",
                parameters: (),
                superclassCall:
                    
                    super.viewHasLoaded()
                    )
        
    }
    
    // ["name": "setupView", "returnSignature": "", "fullyQualifiedName": "setupView(data: Any)", "parameterSignature": "data: Any", "parameterSignatureWithoutNames": "data: Any", "inputTypes": "Any", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "data", "call": "data: data", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("data"), name: "data", type: "Any", range: CountableRange(669..<678), nameRange: CountableRange(669..<673))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func setupView(data: Any)  {
        
            return cuckoo_manager.call("setupView(data: Any)",
                parameters: (data),
                superclassCall:
                    
                    super.setupView(data: data)
                    )
        
    }
    
    // ["name": "close", "returnSignature": "", "fullyQualifiedName": "close()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func close()  {
        
            return cuckoo_manager.call("close()",
                parameters: (),
                superclassCall:
                    
                    super.close()
                    )
        
    }
    
    // ["name": "generateReport", "returnSignature": "", "fullyQualifiedName": "generateReport()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func generateReport()  {
        
            return cuckoo_manager.call("generateReport()",
                parameters: (),
                superclassCall:
                    
                    super.generateReport()
                    )
        
    }
    
    // ["name": "presentAlert", "returnSignature": "", "fullyQualifiedName": "presentAlert(title: String, message: String)", "parameterSignature": "title: String, message: String", "parameterSignatureWithoutNames": "title: String, message: String", "inputTypes": "String, String", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "title, message", "call": "title: title, message: message", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("title"), name: "title", type: "String", range: CountableRange(980..<993), nameRange: CountableRange(980..<985)), CuckooGeneratorFramework.MethodParameter(label: Optional("message"), name: "message", type: "String", range: CountableRange(995..<1010), nameRange: CountableRange(995..<1002))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func presentAlert(title: String, message: String)  {
        
            return cuckoo_manager.call("presentAlert(title: String, message: String)",
                parameters: (title, message),
                superclassCall:
                    
                    super.presentAlert(title: title, message: message)
                    )
        
    }
    
    // ["name": "presentSheet", "returnSignature": "", "fullyQualifiedName": "presentSheet(title: String?, message: String?, actions: [UIAlertAction])", "parameterSignature": "title: String?, message: String?, actions: [UIAlertAction]", "parameterSignatureWithoutNames": "title: String?, message: String?, actions: [UIAlertAction]", "inputTypes": "String?, String?, [UIAlertAction]", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "title, message, actions", "call": "title: title, message: message, actions: actions", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("title"), name: "title", type: "String?", range: CountableRange(1104..<1118), nameRange: CountableRange(1104..<1109)), CuckooGeneratorFramework.MethodParameter(label: Optional("message"), name: "message", type: "String?", range: CountableRange(1120..<1136), nameRange: CountableRange(1120..<1127)), CuckooGeneratorFramework.MethodParameter(label: Optional("actions"), name: "actions", type: "[UIAlertAction]", range: CountableRange(1138..<1162), nameRange: CountableRange(1138..<1145))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func presentSheet(title: String?, message: String?, actions: [UIAlertAction])  {
        
            return cuckoo_manager.call("presentSheet(title: String?, message: String?, actions: [UIAlertAction])",
                parameters: (title, message, actions),
                superclassCall:
                    
                    super.presentSheet(title: title, message: message, actions: actions)
                    )
        
    }
    
    // ["name": "present", "returnSignature": "", "fullyQualifiedName": "present(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)", "parameterSignature": "vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?", "parameterSignatureWithoutNames": "vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?", "inputTypes": "UIViewController, Bool, Bool, (() -> Void)?", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "", "parameterNames": "vc, animated, isPopover, completion", "call": "vc: vc, animated: animated, isPopover: isPopover, completion: completion", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("vc"), name: "vc", type: "UIViewController", range: CountableRange(1269..<1289), nameRange: CountableRange(1269..<1271)), CuckooGeneratorFramework.MethodParameter(label: Optional("animated"), name: "animated", type: "Bool", range: CountableRange(1291..<1312), nameRange: CountableRange(1291..<1299)), CuckooGeneratorFramework.MethodParameter(label: Optional("isPopover"), name: "isPopover", type: "Bool", range: CountableRange(1314..<1337), nameRange: CountableRange(1314..<1323)), CuckooGeneratorFramework.MethodParameter(label: Optional("completion"), name: "completion", type: "(() -> Void)?", range: CountableRange(1339..<1370), nameRange: CountableRange(1339..<1349))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func present(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)  {
        
            return cuckoo_manager.call("present(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)",
                parameters: (vc, animated, isPopover, completion),
                superclassCall:
                    
                    super.present(vc: vc, animated: animated, isPopover: isPopover, completion: completion)
                    )
        
    }
    
    // ["name": "presentOutputSettings", "returnSignature": "", "fullyQualifiedName": "presentOutputSettings()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func presentOutputSettings()  {
        
            return cuckoo_manager.call("presentOutputSettings()",
                parameters: (),
                superclassCall:
                    
                    super.presentOutputSettings()
                    )
        
    }
    
    // ["name": "hideHudFromView", "returnSignature": "", "fullyQualifiedName": "hideHudFromView()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func hideHudFromView()  {
        
            return cuckoo_manager.call("hideHudFromView()",
                parameters: (),
                superclassCall:
                    
                    super.hideHudFromView()
                    )
        
    }
    
    // ["name": "presentEnableDistances", "returnSignature": "", "fullyQualifiedName": "presentEnableDistances()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func presentEnableDistances()  {
        
            return cuckoo_manager.call("presentEnableDistances()",
                parameters: (),
                superclassCall:
                    
                    super.presentEnableDistances()
                    )
        
    }
    

	struct __StubbingProxy_GenerateReportPresenter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method: "viewHasLoaded()", parameterMatchers: matchers))
	    }
	    
	    func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.ClassStubNoReturnFunction<(Any)> where M1.MatchedType == Any {
	        let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method: "setupView(data: Any)", parameterMatchers: matchers))
	    }
	    
	    func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method: "close()", parameterMatchers: matchers))
	    }
	    
	    func generateReport() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method: "generateReport()", parameterMatchers: matchers))
	    }
	    
	    func presentAlert<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(title: M1, message: M2) -> Cuckoo.ClassStubNoReturnFunction<(String, String)> where M1.MatchedType == String, M2.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method: "presentAlert(title: String, message: String)", parameterMatchers: matchers))
	    }
	    
	    func presentSheet<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(title: M1, message: M2, actions: M3) -> Cuckoo.ClassStubNoReturnFunction<(String?, String?, [UIAlertAction])> where M1.MatchedType == String?, M2.MatchedType == String?, M3.MatchedType == [UIAlertAction] {
	        let matchers: [Cuckoo.ParameterMatcher<(String?, String?, [UIAlertAction])>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }, wrap(matchable: actions) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method: "presentSheet(title: String?, message: String?, actions: [UIAlertAction])", parameterMatchers: matchers))
	    }
	    
	    func present<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(vc: M1, animated: M2, isPopover: M3, completion: M4) -> Cuckoo.ClassStubNoReturnFunction<(UIViewController, Bool, Bool, (() -> Void)?)> where M1.MatchedType == UIViewController, M2.MatchedType == Bool, M3.MatchedType == Bool, M4.MatchedType == (() -> Void)? {
	        let matchers: [Cuckoo.ParameterMatcher<(UIViewController, Bool, Bool, (() -> Void)?)>] = [wrap(matchable: vc) { $0.0 }, wrap(matchable: animated) { $0.1 }, wrap(matchable: isPopover) { $0.2 }, wrap(matchable: completion) { $0.3 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method: "present(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)", parameterMatchers: matchers))
	    }
	    
	    func presentOutputSettings() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method: "presentOutputSettings()", parameterMatchers: matchers))
	    }
	    
	    func hideHudFromView() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method: "hideHudFromView()", parameterMatchers: matchers))
	    }
	    
	    func presentEnableDistances() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportPresenter.self, method: "presentEnableDistances()", parameterMatchers: matchers))
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
	    func presentOutputSettings() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("presentOutputSettings()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func hideHudFromView() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("hideHudFromView()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func presentEnableDistances() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("presentEnableDistances()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
    
     override func presentOutputSettings()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func hideHudFromView()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func presentEnableDistances()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/Generate Report/GenerateReportRouter.swift
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

class MockGenerateReportRouter: GenerateReportRouter, Cuckoo.ClassMock {
    typealias MocksType = GenerateReportRouter
    typealias Stubbing = __StubbingProxy_GenerateReportRouter
    typealias Verification = __VerificationProxy_GenerateReportRouter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "close", "returnSignature": "", "fullyQualifiedName": "close()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func close()  {
        
            return cuckoo_manager.call("close()",
                parameters: (),
                superclassCall:
                    
                    super.close()
                    )
        
    }
    
    // ["name": "openSheet", "returnSignature": "", "fullyQualifiedName": "openSheet(title: String?, message: String?, actions: [UIAlertAction])", "parameterSignature": "title: String?, message: String?, actions: [UIAlertAction]", "parameterSignatureWithoutNames": "title: String?, message: String?, actions: [UIAlertAction]", "inputTypes": "String?, String?, [UIAlertAction]", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "title, message, actions", "call": "title: title, message: message, actions: actions", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("title"), name: "title", type: "String?", range: CountableRange(336..<350), nameRange: CountableRange(336..<341)), CuckooGeneratorFramework.MethodParameter(label: Optional("message"), name: "message", type: "String?", range: CountableRange(352..<368), nameRange: CountableRange(352..<359)), CuckooGeneratorFramework.MethodParameter(label: Optional("actions"), name: "actions", type: "[UIAlertAction]", range: CountableRange(370..<394), nameRange: CountableRange(370..<377))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openSheet(title: String?, message: String?, actions: [UIAlertAction])  {
        
            return cuckoo_manager.call("openSheet(title: String?, message: String?, actions: [UIAlertAction])",
                parameters: (title, message, actions),
                superclassCall:
                    
                    super.openSheet(title: title, message: message, actions: actions)
                    )
        
    }
    
    // ["name": "openSettingsOnDisatnce", "returnSignature": "", "fullyQualifiedName": "openSettingsOnDisatnce()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openSettingsOnDisatnce()  {
        
            return cuckoo_manager.call("openSettingsOnDisatnce()",
                parameters: (),
                superclassCall:
                    
                    super.openSettingsOnDisatnce()
                    )
        
    }
    
    // ["name": "openSettingsOnReportLayout", "returnSignature": "", "fullyQualifiedName": "openSettingsOnReportLayout()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openSettingsOnReportLayout()  {
        
            return cuckoo_manager.call("openSettingsOnReportLayout()",
                parameters: (),
                superclassCall:
                    
                    super.openSettingsOnReportLayout()
                    )
        
    }
    
    // ["name": "openSettings", "returnSignature": "", "fullyQualifiedName": "openSettings(option: ShowSettingsOption)", "parameterSignature": "option: ShowSettingsOption", "parameterSignatureWithoutNames": "option: ShowSettingsOption", "inputTypes": "ShowSettingsOption", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "option", "call": "option: option", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("option"), name: "option", type: "ShowSettingsOption", range: CountableRange(955..<981), nameRange: CountableRange(955..<961))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openSettings(option: ShowSettingsOption)  {
        
            return cuckoo_manager.call("openSettings(option: ShowSettingsOption)",
                parameters: (option),
                superclassCall:
                    
                    super.openSettings(option: option)
                    )
        
    }
    
    // ["name": "open", "returnSignature": "", "fullyQualifiedName": "open(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)", "parameterSignature": "vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?", "parameterSignatureWithoutNames": "vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?", "inputTypes": "UIViewController, Bool, Bool, (() -> Void)?", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "", "parameterNames": "vc, animated, isPopover, completion", "call": "vc: vc, animated: animated, isPopover: isPopover, completion: completion", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("vc"), name: "vc", type: "UIViewController", range: CountableRange(1323..<1343), nameRange: CountableRange(1323..<1325)), CuckooGeneratorFramework.MethodParameter(label: Optional("animated"), name: "animated", type: "Bool", range: CountableRange(1345..<1366), nameRange: CountableRange(1345..<1353)), CuckooGeneratorFramework.MethodParameter(label: Optional("isPopover"), name: "isPopover", type: "Bool", range: CountableRange(1368..<1391), nameRange: CountableRange(1368..<1377)), CuckooGeneratorFramework.MethodParameter(label: Optional("completion"), name: "completion", type: "(() -> Void)?", range: CountableRange(1393..<1424), nameRange: CountableRange(1393..<1403))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func open(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)  {
        
            return cuckoo_manager.call("open(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)",
                parameters: (vc, animated, isPopover, completion),
                superclassCall:
                    
                    super.open(vc: vc, animated: animated, isPopover: isPopover, completion: completion)
                    )
        
    }
    

	struct __StubbingProxy_GenerateReportRouter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportRouter.self, method: "close()", parameterMatchers: matchers))
	    }
	    
	    func openSheet<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(title: M1, message: M2, actions: M3) -> Cuckoo.ClassStubNoReturnFunction<(String?, String?, [UIAlertAction])> where M1.MatchedType == String?, M2.MatchedType == String?, M3.MatchedType == [UIAlertAction] {
	        let matchers: [Cuckoo.ParameterMatcher<(String?, String?, [UIAlertAction])>] = [wrap(matchable: title) { $0.0 }, wrap(matchable: message) { $0.1 }, wrap(matchable: actions) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportRouter.self, method: "openSheet(title: String?, message: String?, actions: [UIAlertAction])", parameterMatchers: matchers))
	    }
	    
	    func openSettingsOnDisatnce() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportRouter.self, method: "openSettingsOnDisatnce()", parameterMatchers: matchers))
	    }
	    
	    func openSettingsOnReportLayout() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportRouter.self, method: "openSettingsOnReportLayout()", parameterMatchers: matchers))
	    }
	    
	    func openSettings<M1: Cuckoo.Matchable>(option: M1) -> Cuckoo.ClassStubNoReturnFunction<(ShowSettingsOption)> where M1.MatchedType == ShowSettingsOption {
	        let matchers: [Cuckoo.ParameterMatcher<(ShowSettingsOption)>] = [wrap(matchable: option) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportRouter.self, method: "openSettings(option: ShowSettingsOption)", parameterMatchers: matchers))
	    }
	    
	    func open<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(vc: M1, animated: M2, isPopover: M3, completion: M4) -> Cuckoo.ClassStubNoReturnFunction<(UIViewController, Bool, Bool, (() -> Void)?)> where M1.MatchedType == UIViewController, M2.MatchedType == Bool, M3.MatchedType == Bool, M4.MatchedType == (() -> Void)? {
	        let matchers: [Cuckoo.ParameterMatcher<(UIViewController, Bool, Bool, (() -> Void)?)>] = [wrap(matchable: vc) { $0.0 }, wrap(matchable: animated) { $0.1 }, wrap(matchable: isPopover) { $0.2 }, wrap(matchable: completion) { $0.3 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockGenerateReportRouter.self, method: "open(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)", parameterMatchers: matchers))
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
	    func openSettingsOnDisatnce() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("openSettingsOnDisatnce()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func openSettingsOnReportLayout() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("openSettingsOnReportLayout()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func openSettings<M1: Cuckoo.Matchable>(option: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == ShowSettingsOption {
	        let matchers: [Cuckoo.ParameterMatcher<(ShowSettingsOption)>] = [wrap(matchable: option) { $0 }]
	        return cuckoo_manager.verify("openSettings(option: ShowSettingsOption)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
    
     override func openSettingsOnDisatnce()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openSettingsOnReportLayout()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openSettings(option: ShowSettingsOption)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func open(vc: UIViewController, animated: Bool, isPopover: Bool, completion: (() -> Void)?)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/OCR Configuration/OCRConfigurationInteractor.swift
//
//  OCRConfigurationInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/10/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import StoreKit
import Toaster
import Viperit

class MockOCRConfigurationInteractor: OCRConfigurationInteractor, Cuckoo.ClassMock {
    typealias MocksType = OCRConfigurationInteractor
    typealias Stubbing = __StubbingProxy_OCRConfigurationInteractor
    typealias Verification = __VerificationProxy_OCRConfigurationInteractor
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "requestProducts", "returnSignature": " -> Observable<SKProduct>", "fullyQualifiedName": "requestProducts() -> Observable<SKProduct>", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Observable<SKProduct>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func requestProducts()  -> Observable<SKProduct> {
        
            return cuckoo_manager.call("requestProducts() -> Observable<SKProduct>",
                parameters: (),
                superclassCall:
                    
                    super.requestProducts()
                    )
        
    }
    
    // ["name": "purchase", "returnSignature": "", "fullyQualifiedName": "purchase(product: String)", "parameterSignature": "product: String", "parameterSignatureWithoutNames": "product: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "product", "call": "product: product", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("product"), name: "product", type: "String", range: CountableRange(717..<732), nameRange: CountableRange(717..<724))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func purchase(product: String)  {
        
            return cuckoo_manager.call("purchase(product: String)",
                parameters: (product),
                superclassCall:
                    
                    super.purchase(product: product)
                    )
        
    }
    

	struct __StubbingProxy_OCRConfigurationInteractor: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func requestProducts() -> Cuckoo.ClassStubFunction<(), Observable<SKProduct>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockOCRConfigurationInteractor.self, method: "requestProducts() -> Observable<SKProduct>", parameterMatchers: matchers))
	    }
	    
	    func purchase<M1: Cuckoo.Matchable>(product: M1) -> Cuckoo.ClassStubNoReturnFunction<(String)> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: product) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockOCRConfigurationInteractor.self, method: "purchase(product: String)", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_OCRConfigurationInteractor: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func requestProducts() -> Cuckoo.__DoNotUse<Observable<SKProduct>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("requestProducts() -> Observable<SKProduct>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func purchase<M1: Cuckoo.Matchable>(product: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: product) { $0 }]
	        return cuckoo_manager.verify("purchase(product: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class OCRConfigurationInteractorStub: OCRConfigurationInteractor {
    

    

    
     override func requestProducts()  -> Observable<SKProduct> {
        return DefaultValueRegistry.defaultValue(for: Observable<SKProduct>.self)
    }
    
     override func purchase(product: String)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/OCR Configuration/OCRConfigurationPresenter.swift
//
//  OCRConfigurationPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/10/2017.
//Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import RxSwift
import StoreKit
import Viperit

class MockOCRConfigurationPresenter: OCRConfigurationPresenter, Cuckoo.ClassMock {
    typealias MocksType = OCRConfigurationPresenter
    typealias Stubbing = __StubbingProxy_OCRConfigurationPresenter
    typealias Verification = __VerificationProxy_OCRConfigurationPresenter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "viewHasLoaded", "returnSignature": "", "fullyQualifiedName": "viewHasLoaded()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func viewHasLoaded()  {
        
            return cuckoo_manager.call("viewHasLoaded()",
                parameters: (),
                superclassCall:
                    
                    super.viewHasLoaded()
                    )
        
    }
    

	struct __StubbingProxy_OCRConfigurationPresenter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockOCRConfigurationPresenter.self, method: "viewHasLoaded()", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_OCRConfigurationPresenter: Cuckoo.VerificationProxy {
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
	    
	}

}

 class OCRConfigurationPresenterStub: OCRConfigurationPresenter {
    

    

    
     override func viewHasLoaded()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/OCR Configuration/OCRConfigurationRouter.swift
//
//  OCRConfigurationRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/10/2017.
//Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Foundation
import Viperit

class MockOCRConfigurationRouter: OCRConfigurationRouter, Cuckoo.ClassMock {
    typealias MocksType = OCRConfigurationRouter
    typealias Stubbing = __StubbingProxy_OCRConfigurationRouter
    typealias Verification = __VerificationProxy_OCRConfigurationRouter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    

	struct __StubbingProxy_OCRConfigurationRouter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	}

	struct __VerificationProxy_OCRConfigurationRouter: Cuckoo.VerificationProxy {
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

 class OCRConfigurationRouterStub: OCRConfigurationRouter {
    

    

    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/Payment Methods/PaymentMethodsInteractor.swift
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

class MockPaymentMethodsInteractor: PaymentMethodsInteractor, Cuckoo.ClassMock {
    typealias MocksType = PaymentMethodsInteractor
    typealias Stubbing = __StubbingProxy_PaymentMethodsInteractor
    typealias Verification = __VerificationProxy_PaymentMethodsInteractor
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "configureSubscribers", "returnSignature": "", "fullyQualifiedName": "configureSubscribers()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func configureSubscribers()  {
        
            return cuckoo_manager.call("configureSubscribers()",
                parameters: (),
                superclassCall:
                    
                    super.configureSubscribers()
                    )
        
    }
    
    // ["name": "fetchedModelAdapter", "returnSignature": " -> FetchedModelAdapter?", "fullyQualifiedName": "fetchedModelAdapter() -> FetchedModelAdapter?", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Optional<FetchedModelAdapter>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        
            return cuckoo_manager.call("fetchedModelAdapter() -> FetchedModelAdapter?",
                parameters: (),
                superclassCall:
                    
                    super.fetchedModelAdapter()
                    )
        
    }
    
    // ["name": "save", "returnSignature": "", "fullyQualifiedName": "save(paymentMethod: PaymentMethod, update: Bool)", "parameterSignature": "paymentMethod: PaymentMethod, update: Bool", "parameterSignatureWithoutNames": "paymentMethod: PaymentMethod, update: Bool", "inputTypes": "PaymentMethod, Bool", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "paymentMethod, update", "call": "paymentMethod: paymentMethod, update: update", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("paymentMethod"), name: "paymentMethod", type: "PaymentMethod", range: CountableRange(870..<898), nameRange: CountableRange(870..<883)), CuckooGeneratorFramework.MethodParameter(label: Optional("update"), name: "update", type: "Bool", range: CountableRange(900..<912), nameRange: CountableRange(900..<906))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func save(paymentMethod: PaymentMethod, update: Bool)  {
        
            return cuckoo_manager.call("save(paymentMethod: PaymentMethod, update: Bool)",
                parameters: (paymentMethod, update),
                superclassCall:
                    
                    super.save(paymentMethod: paymentMethod, update: update)
                    )
        
    }
    
    // ["name": "delete", "returnSignature": "", "fullyQualifiedName": "delete(paymentMethod: PaymentMethod)", "parameterSignature": "paymentMethod: PaymentMethod", "parameterSignatureWithoutNames": "paymentMethod: PaymentMethod", "inputTypes": "PaymentMethod", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "paymentMethod", "call": "paymentMethod: paymentMethod", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("paymentMethod"), name: "paymentMethod", type: "PaymentMethod", range: CountableRange(1278..<1306), nameRange: CountableRange(1278..<1291))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func delete(paymentMethod: PaymentMethod)  {
        
            return cuckoo_manager.call("delete(paymentMethod: PaymentMethod)",
                parameters: (paymentMethod),
                superclassCall:
                    
                    super.delete(paymentMethod: paymentMethod)
                    )
        
    }
    

	struct __StubbingProxy_PaymentMethodsInteractor: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func configureSubscribers() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPaymentMethodsInteractor.self, method: "configureSubscribers()", parameterMatchers: matchers))
	    }
	    
	    func fetchedModelAdapter() -> Cuckoo.ClassStubFunction<(), Optional<FetchedModelAdapter>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPaymentMethodsInteractor.self, method: "fetchedModelAdapter() -> FetchedModelAdapter?", parameterMatchers: matchers))
	    }
	    
	    func save<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(paymentMethod: M1, update: M2) -> Cuckoo.ClassStubNoReturnFunction<(PaymentMethod, Bool)> where M1.MatchedType == PaymentMethod, M2.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(PaymentMethod, Bool)>] = [wrap(matchable: paymentMethod) { $0.0 }, wrap(matchable: update) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPaymentMethodsInteractor.self, method: "save(paymentMethod: PaymentMethod, update: Bool)", parameterMatchers: matchers))
	    }
	    
	    func delete<M1: Cuckoo.Matchable>(paymentMethod: M1) -> Cuckoo.ClassStubNoReturnFunction<(PaymentMethod)> where M1.MatchedType == PaymentMethod {
	        let matchers: [Cuckoo.ParameterMatcher<(PaymentMethod)>] = [wrap(matchable: paymentMethod) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPaymentMethodsInteractor.self, method: "delete(paymentMethod: PaymentMethod)", parameterMatchers: matchers))
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


// MARK: - Mocks generated from file: SmartReceipts/Modules/Payment Methods/PaymentMethodsPresenter.swift
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

class MockPaymentMethodsPresenter: PaymentMethodsPresenter, Cuckoo.ClassMock {
    typealias MocksType = PaymentMethodsPresenter
    typealias Stubbing = __StubbingProxy_PaymentMethodsPresenter
    typealias Verification = __VerificationProxy_PaymentMethodsPresenter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "viewHasLoaded", "returnSignature": "", "fullyQualifiedName": "viewHasLoaded()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func viewHasLoaded()  {
        
            return cuckoo_manager.call("viewHasLoaded()",
                parameters: (),
                superclassCall:
                    
                    super.viewHasLoaded()
                    )
        
    }
    
    // ["name": "fetchedModelAdapter", "returnSignature": " -> FetchedModelAdapter?", "fullyQualifiedName": "fetchedModelAdapter() -> FetchedModelAdapter?", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Optional<FetchedModelAdapter>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        
            return cuckoo_manager.call("fetchedModelAdapter() -> FetchedModelAdapter?",
                parameters: (),
                superclassCall:
                    
                    super.fetchedModelAdapter()
                    )
        
    }
    

	struct __StubbingProxy_PaymentMethodsPresenter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPaymentMethodsPresenter.self, method: "viewHasLoaded()", parameterMatchers: matchers))
	    }
	    
	    func fetchedModelAdapter() -> Cuckoo.ClassStubFunction<(), Optional<FetchedModelAdapter>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPaymentMethodsPresenter.self, method: "fetchedModelAdapter() -> FetchedModelAdapter?", parameterMatchers: matchers))
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
    
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        return DefaultValueRegistry.defaultValue(for: Optional<FetchedModelAdapter>.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/Payment Methods/PaymentMethodsRouter.swift
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

class MockPaymentMethodsRouter: PaymentMethodsRouter, Cuckoo.ClassMock {
    typealias MocksType = PaymentMethodsRouter
    typealias Stubbing = __StubbingProxy_PaymentMethodsRouter
    typealias Verification = __VerificationProxy_PaymentMethodsRouter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    

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


// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipt Actions/ReceiptActionsInteractor.swift
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

class MockReceiptActionsInteractor: ReceiptActionsInteractor, Cuckoo.ClassMock {
    typealias MocksType = ReceiptActionsInteractor
    typealias Stubbing = __StubbingProxy_ReceiptActionsInteractor
    typealias Verification = __VerificationProxy_ReceiptActionsInteractor
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "attachAppInputFile", "returnSignature": " -> Bool", "fullyQualifiedName": "attachAppInputFile(to: WBReceipt) -> Bool", "parameterSignature": "to receipt: WBReceipt", "parameterSignatureWithoutNames": "receipt: WBReceipt", "inputTypes": "WBReceipt", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "receipt", "call": "to: receipt", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("to"), name: "receipt", type: "WBReceipt", range: CountableRange(277..<298), nameRange: CountableRange(277..<279))], "returnType": "Bool", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func attachAppInputFile(to receipt: WBReceipt)  -> Bool {
        
            return cuckoo_manager.call("attachAppInputFile(to: WBReceipt) -> Bool",
                parameters: (receipt),
                superclassCall:
                    
                    super.attachAppInputFile(to: receipt)
                    )
        
    }
    
    // ["name": "attachImage", "returnSignature": " -> Bool", "fullyQualifiedName": "attachImage(_: UIImage, to: WBReceipt) -> Bool", "parameterSignature": "_ image: UIImage, to receipt: WBReceipt", "parameterSignatureWithoutNames": "image: UIImage, receipt: WBReceipt", "inputTypes": "UIImage, WBReceipt", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "image, receipt", "call": "image, to: receipt", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "image", type: "UIImage", range: CountableRange(468..<484), nameRange: CountableRange(0..<0)), CuckooGeneratorFramework.MethodParameter(label: Optional("to"), name: "receipt", type: "WBReceipt", range: CountableRange(486..<507), nameRange: CountableRange(486..<488))], "returnType": "Bool", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func attachImage(_ image: UIImage, to receipt: WBReceipt)  -> Bool {
        
            return cuckoo_manager.call("attachImage(_: UIImage, to: WBReceipt) -> Bool",
                parameters: (image, receipt),
                superclassCall:
                    
                    super.attachImage(image, to: receipt)
                    )
        
    }
    

	struct __StubbingProxy_ReceiptActionsInteractor: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func attachAppInputFile<M1: Cuckoo.Matchable>(to receipt: M1) -> Cuckoo.ClassStubFunction<(WBReceipt), Bool> where M1.MatchedType == WBReceipt {
	        let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptActionsInteractor.self, method: "attachAppInputFile(to: WBReceipt) -> Bool", parameterMatchers: matchers))
	    }
	    
	    func attachImage<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ image: M1, to receipt: M2) -> Cuckoo.ClassStubFunction<(UIImage, WBReceipt), Bool> where M1.MatchedType == UIImage, M2.MatchedType == WBReceipt {
	        let matchers: [Cuckoo.ParameterMatcher<(UIImage, WBReceipt)>] = [wrap(matchable: image) { $0.0 }, wrap(matchable: receipt) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptActionsInteractor.self, method: "attachImage(_: UIImage, to: WBReceipt) -> Bool", parameterMatchers: matchers))
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


// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipt Actions/ReceiptActionsPresenter.swift
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

class MockReceiptActionsPresenter: ReceiptActionsPresenter, Cuckoo.ClassMock {
    typealias MocksType = ReceiptActionsPresenter
    typealias Stubbing = __StubbingProxy_ReceiptActionsPresenter
    typealias Verification = __VerificationProxy_ReceiptActionsPresenter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "setupView", "returnSignature": "", "fullyQualifiedName": "setupView(data: Any)", "parameterSignature": "data: Any", "parameterSignatureWithoutNames": "data: Any", "inputTypes": "Any", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "data", "call": "data: data", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("data"), name: "data", type: "Any", range: CountableRange(864..<873), nameRange: CountableRange(864..<868))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func setupView(data: Any)  {
        
            return cuckoo_manager.call("setupView(data: Any)",
                parameters: (data),
                superclassCall:
                    
                    super.setupView(data: data)
                    )
        
    }
    
    // ["name": "viewHasLoaded", "returnSignature": "", "fullyQualifiedName": "viewHasLoaded()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func viewHasLoaded()  {
        
            return cuckoo_manager.call("viewHasLoaded()",
                parameters: (),
                superclassCall:
                    
                    super.viewHasLoaded()
                    )
        
    }
    
    // ["name": "configureSubscribers", "returnSignature": "", "fullyQualifiedName": "configureSubscribers()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func configureSubscribers()  {
        
            return cuckoo_manager.call("configureSubscribers()",
                parameters: (),
                superclassCall:
                    
                    super.configureSubscribers()
                    )
        
    }
    

	struct __StubbingProxy_ReceiptActionsPresenter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.ClassStubNoReturnFunction<(Any)> where M1.MatchedType == Any {
	        let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptActionsPresenter.self, method: "setupView(data: Any)", parameterMatchers: matchers))
	    }
	    
	    func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptActionsPresenter.self, method: "viewHasLoaded()", parameterMatchers: matchers))
	    }
	    
	    func configureSubscribers() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptActionsPresenter.self, method: "configureSubscribers()", parameterMatchers: matchers))
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


// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipt Actions/ReceiptActionsRouter.swift
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

class MockReceiptActionsRouter: ReceiptActionsRouter, Cuckoo.ClassMock {
    typealias MocksType = ReceiptActionsRouter
    typealias Stubbing = __StubbingProxy_ReceiptActionsRouter
    typealias Verification = __VerificationProxy_ReceiptActionsRouter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "close", "returnSignature": "", "fullyQualifiedName": "close()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func close()  {
        
            return cuckoo_manager.call("close()",
                parameters: (),
                superclassCall:
                    
                    super.close()
                    )
        
    }
    
    // ["name": "openMove", "returnSignature": "", "fullyQualifiedName": "openMove(receipt: WBReceipt)", "parameterSignature": "receipt: WBReceipt", "parameterSignatureWithoutNames": "receipt: WBReceipt", "inputTypes": "WBReceipt", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "receipt", "call": "receipt: receipt", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("receipt"), name: "receipt", type: "WBReceipt", range: CountableRange(340..<358), nameRange: CountableRange(340..<347))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openMove(receipt: WBReceipt)  {
        
            return cuckoo_manager.call("openMove(receipt: WBReceipt)",
                parameters: (receipt),
                superclassCall:
                    
                    super.openMove(receipt: receipt)
                    )
        
    }
    
    // ["name": "openCopy", "returnSignature": "", "fullyQualifiedName": "openCopy(receipt: WBReceipt)", "parameterSignature": "receipt: WBReceipt", "parameterSignatureWithoutNames": "receipt: WBReceipt", "inputTypes": "WBReceipt", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "receipt", "call": "receipt: receipt", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("receipt"), name: "receipt", type: "WBReceipt", range: CountableRange(449..<467), nameRange: CountableRange(449..<456))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openCopy(receipt: WBReceipt)  {
        
            return cuckoo_manager.call("openCopy(receipt: WBReceipt)",
                parameters: (receipt),
                superclassCall:
                    
                    super.openCopy(receipt: receipt)
                    )
        
    }
    

	struct __StubbingProxy_ReceiptActionsRouter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptActionsRouter.self, method: "close()", parameterMatchers: matchers))
	    }
	    
	    func openMove<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
	        let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptActionsRouter.self, method: "openMove(receipt: WBReceipt)", parameterMatchers: matchers))
	    }
	    
	    func openCopy<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
	        let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptActionsRouter.self, method: "openCopy(receipt: WBReceipt)", parameterMatchers: matchers))
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


// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipt Move Copy/ReceiptMoveCopyInteractor.swift
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

class MockReceiptMoveCopyInteractor: ReceiptMoveCopyInteractor, Cuckoo.ClassMock {
    typealias MocksType = ReceiptMoveCopyInteractor
    typealias Stubbing = __StubbingProxy_ReceiptMoveCopyInteractor
    typealias Verification = __VerificationProxy_ReceiptMoveCopyInteractor
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "configureSubscribers", "returnSignature": "", "fullyQualifiedName": "configureSubscribers()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func configureSubscribers()  {
        
            return cuckoo_manager.call("configureSubscribers()",
                parameters: (),
                superclassCall:
                    
                    super.configureSubscribers()
                    )
        
    }
    
    // ["name": "fetchedModelAdapter", "returnSignature": " -> FetchedModelAdapter", "fullyQualifiedName": "fetchedModelAdapter(for: WBReceipt) -> FetchedModelAdapter", "parameterSignature": "for receipt: WBReceipt", "parameterSignatureWithoutNames": "receipt: WBReceipt", "inputTypes": "WBReceipt", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "receipt", "call": "for: receipt", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("for"), name: "receipt", type: "WBReceipt", range: CountableRange(748..<770), nameRange: CountableRange(748..<751))], "returnType": "FetchedModelAdapter", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func fetchedModelAdapter(for receipt: WBReceipt)  -> FetchedModelAdapter {
        
            return cuckoo_manager.call("fetchedModelAdapter(for: WBReceipt) -> FetchedModelAdapter",
                parameters: (receipt),
                superclassCall:
                    
                    super.fetchedModelAdapter(for: receipt)
                    )
        
    }
    

	struct __StubbingProxy_ReceiptMoveCopyInteractor: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func configureSubscribers() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptMoveCopyInteractor.self, method: "configureSubscribers()", parameterMatchers: matchers))
	    }
	    
	    func fetchedModelAdapter<M1: Cuckoo.Matchable>(for receipt: M1) -> Cuckoo.ClassStubFunction<(WBReceipt), FetchedModelAdapter> where M1.MatchedType == WBReceipt {
	        let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptMoveCopyInteractor.self, method: "fetchedModelAdapter(for: WBReceipt) -> FetchedModelAdapter", parameterMatchers: matchers))
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


// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipt Move Copy/ReceiptMoveCopyPresenter.swift
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

class MockReceiptMoveCopyPresenter: ReceiptMoveCopyPresenter, Cuckoo.ClassMock {
    typealias MocksType = ReceiptMoveCopyPresenter
    typealias Stubbing = __StubbingProxy_ReceiptMoveCopyPresenter
    typealias Verification = __VerificationProxy_ReceiptMoveCopyPresenter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "isCopy", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Bool!", "isReadOnly": false, "accessibility": ""]
     override var isCopy: Bool! {
        get {
            
            return cuckoo_manager.getter("isCopy", superclassCall: super.isCopy)
            
        }
        
        set {
            
            cuckoo_manager.setter("isCopy", value: newValue, superclassCall: super.isCopy = newValue)
            
        }
        
    }
    
    // ["name": "receipt", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "WBReceipt!", "isReadOnly": false, "accessibility": ""]
     override var receipt: WBReceipt! {
        get {
            
            return cuckoo_manager.getter("receipt", superclassCall: super.receipt)
            
        }
        
        set {
            
            cuckoo_manager.setter("receipt", value: newValue, superclassCall: super.receipt = newValue)
            
        }
        
    }
    

    

    
    // ["name": "viewHasLoaded", "returnSignature": "", "fullyQualifiedName": "viewHasLoaded()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func viewHasLoaded()  {
        
            return cuckoo_manager.call("viewHasLoaded()",
                parameters: (),
                superclassCall:
                    
                    super.viewHasLoaded()
                    )
        
    }
    
    // ["name": "setupView", "returnSignature": "", "fullyQualifiedName": "setupView(data: Any)", "parameterSignature": "data: Any", "parameterSignatureWithoutNames": "data: Any", "inputTypes": "Any", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "data", "call": "data: data", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("data"), name: "data", type: "Any", range: CountableRange(515..<524), nameRange: CountableRange(515..<519))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func setupView(data: Any)  {
        
            return cuckoo_manager.call("setupView(data: Any)",
                parameters: (data),
                superclassCall:
                    
                    super.setupView(data: data)
                    )
        
    }
    
    // ["name": "close", "returnSignature": "", "fullyQualifiedName": "close()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func close()  {
        
            return cuckoo_manager.call("close()",
                parameters: (),
                superclassCall:
                    
                    super.close()
                    )
        
    }
    

	struct __StubbingProxy_ReceiptMoveCopyPresenter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var isCopy: Cuckoo.ClassToBeStubbedProperty<MockReceiptMoveCopyPresenter, Bool?> {
	        return .init(manager: cuckoo_manager, name: "isCopy")
	    }
	    
	    var receipt: Cuckoo.ClassToBeStubbedProperty<MockReceiptMoveCopyPresenter, WBReceipt?> {
	        return .init(manager: cuckoo_manager, name: "receipt")
	    }
	    
	    
	    func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptMoveCopyPresenter.self, method: "viewHasLoaded()", parameterMatchers: matchers))
	    }
	    
	    func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.ClassStubNoReturnFunction<(Any)> where M1.MatchedType == Any {
	        let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptMoveCopyPresenter.self, method: "setupView(data: Any)", parameterMatchers: matchers))
	    }
	    
	    func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptMoveCopyPresenter.self, method: "close()", parameterMatchers: matchers))
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
	
	    
	    var isCopy: Cuckoo.VerifyProperty<Bool?> {
	        return .init(manager: cuckoo_manager, name: "isCopy", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
    
     override var isCopy: Bool! {
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


// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipt Move Copy/ReceiptMoveCopyRouter.swift
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

class MockReceiptMoveCopyRouter: ReceiptMoveCopyRouter, Cuckoo.ClassMock {
    typealias MocksType = ReceiptMoveCopyRouter
    typealias Stubbing = __StubbingProxy_ReceiptMoveCopyRouter
    typealias Verification = __VerificationProxy_ReceiptMoveCopyRouter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "close", "returnSignature": "", "fullyQualifiedName": "close()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func close()  {
        
            return cuckoo_manager.call("close()",
                parameters: (),
                superclassCall:
                    
                    super.close()
                    )
        
    }
    

	struct __StubbingProxy_ReceiptMoveCopyRouter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func close() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptMoveCopyRouter.self, method: "close()", parameterMatchers: matchers))
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


// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipts/ReceiptsInteractor.swift
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

class MockReceiptsInteractor: ReceiptsInteractor, Cuckoo.ClassMock {
    typealias MocksType = ReceiptsInteractor
    typealias Stubbing = __StubbingProxy_ReceiptsInteractor
    typealias Verification = __VerificationProxy_ReceiptsInteractor
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "fetchedModelAdapter", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "FetchedModelAdapter!", "isReadOnly": false, "accessibility": ""]
     override var fetchedModelAdapter: FetchedModelAdapter! {
        get {
            
            return cuckoo_manager.getter("fetchedModelAdapter", superclassCall: super.fetchedModelAdapter)
            
        }
        
        set {
            
            cuckoo_manager.setter("fetchedModelAdapter", value: newValue, superclassCall: super.fetchedModelAdapter = newValue)
            
        }
        
    }
    
    // ["name": "trip", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "WBTrip!", "isReadOnly": false, "accessibility": ""]
     override var trip: WBTrip! {
        get {
            
            return cuckoo_manager.getter("trip", superclassCall: super.trip)
            
        }
        
        set {
            
            cuckoo_manager.setter("trip", value: newValue, superclassCall: super.trip = newValue)
            
        }
        
    }
    
    // ["name": "scanService", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "ScanService!", "isReadOnly": false, "accessibility": ""]
     override var scanService: ScanService! {
        get {
            
            return cuckoo_manager.getter("scanService", superclassCall: super.scanService)
            
        }
        
        set {
            
            cuckoo_manager.setter("scanService", value: newValue, superclassCall: super.scanService = newValue)
            
        }
        
    }
    

    

    
    // ["name": "configureSubscribers", "returnSignature": "", "fullyQualifiedName": "configureSubscribers()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func configureSubscribers()  {
        
            return cuckoo_manager.call("configureSubscribers()",
                parameters: (),
                superclassCall:
                    
                    super.configureSubscribers()
                    )
        
    }
    
    // ["name": "distanceReceipts", "returnSignature": " -> [WBReceipt]", "fullyQualifiedName": "distanceReceipts() -> [WBReceipt]", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "[WBReceipt]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func distanceReceipts()  -> [WBReceipt] {
        
            return cuckoo_manager.call("distanceReceipts() -> [WBReceipt]",
                parameters: (),
                superclassCall:
                    
                    super.distanceReceipts()
                    )
        
    }
    
    // ["name": "fetchedAdapter", "returnSignature": " -> FetchedModelAdapter", "fullyQualifiedName": "fetchedAdapter(for: WBTrip) -> FetchedModelAdapter", "parameterSignature": "for trip: WBTrip", "parameterSignatureWithoutNames": "trip: WBTrip", "inputTypes": "WBTrip", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "trip", "call": "for: trip", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("for"), name: "trip", type: "WBTrip", range: CountableRange(1229..<1245), nameRange: CountableRange(1229..<1232))], "returnType": "FetchedModelAdapter", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func fetchedAdapter(for trip: WBTrip)  -> FetchedModelAdapter {
        
            return cuckoo_manager.call("fetchedAdapter(for: WBTrip) -> FetchedModelAdapter",
                parameters: (trip),
                superclassCall:
                    
                    super.fetchedAdapter(for: trip)
                    )
        
    }
    
    // ["name": "swapUpReceipt", "returnSignature": "", "fullyQualifiedName": "swapUpReceipt(_: WBReceipt)", "parameterSignature": "_ receipt: WBReceipt", "parameterSignatureWithoutNames": "receipt: WBReceipt", "inputTypes": "WBReceipt", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "receipt", "call": "receipt", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "receipt", type: "WBReceipt", range: CountableRange(1431..<1451), nameRange: CountableRange(0..<0))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func swapUpReceipt(_ receipt: WBReceipt)  {
        
            return cuckoo_manager.call("swapUpReceipt(_: WBReceipt)",
                parameters: (receipt),
                superclassCall:
                    
                    super.swapUpReceipt(receipt)
                    )
        
    }
    
    // ["name": "swapDownReceipt", "returnSignature": "", "fullyQualifiedName": "swapDownReceipt(_: WBReceipt)", "parameterSignature": "_ receipt: WBReceipt", "parameterSignatureWithoutNames": "receipt: WBReceipt", "inputTypes": "WBReceipt", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "receipt", "call": "receipt", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "receipt", type: "WBReceipt", range: CountableRange(1672..<1692), nameRange: CountableRange(0..<0))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func swapDownReceipt(_ receipt: WBReceipt)  {
        
            return cuckoo_manager.call("swapDownReceipt(_: WBReceipt)",
                parameters: (receipt),
                superclassCall:
                    
                    super.swapDownReceipt(receipt)
                    )
        
    }
    
    // ["name": "titleSubtitle", "returnSignature": " -> TitleSubtitle", "fullyQualifiedName": "titleSubtitle() -> TitleSubtitle", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "TitleSubtitle", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func titleSubtitle()  -> TitleSubtitle {
        
            return cuckoo_manager.call("titleSubtitle() -> TitleSubtitle",
                parameters: (),
                superclassCall:
                    
                    super.titleSubtitle()
                    )
        
    }
    

	struct __StubbingProxy_ReceiptsInteractor: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var fetchedModelAdapter: Cuckoo.ClassToBeStubbedProperty<MockReceiptsInteractor, FetchedModelAdapter?> {
	        return .init(manager: cuckoo_manager, name: "fetchedModelAdapter")
	    }
	    
	    var trip: Cuckoo.ClassToBeStubbedProperty<MockReceiptsInteractor, WBTrip?> {
	        return .init(manager: cuckoo_manager, name: "trip")
	    }
	    
	    var scanService: Cuckoo.ClassToBeStubbedProperty<MockReceiptsInteractor, ScanService?> {
	        return .init(manager: cuckoo_manager, name: "scanService")
	    }
	    
	    
	    func configureSubscribers() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptsInteractor.self, method: "configureSubscribers()", parameterMatchers: matchers))
	    }
	    
	    func distanceReceipts() -> Cuckoo.ClassStubFunction<(), [WBReceipt]> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptsInteractor.self, method: "distanceReceipts() -> [WBReceipt]", parameterMatchers: matchers))
	    }
	    
	    func fetchedAdapter<M1: Cuckoo.Matchable>(for trip: M1) -> Cuckoo.ClassStubFunction<(WBTrip), FetchedModelAdapter> where M1.MatchedType == WBTrip {
	        let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptsInteractor.self, method: "fetchedAdapter(for: WBTrip) -> FetchedModelAdapter", parameterMatchers: matchers))
	    }
	    
	    func swapUpReceipt<M1: Cuckoo.Matchable>(_ receipt: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
	        let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptsInteractor.self, method: "swapUpReceipt(_: WBReceipt)", parameterMatchers: matchers))
	    }
	    
	    func swapDownReceipt<M1: Cuckoo.Matchable>(_ receipt: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
	        let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptsInteractor.self, method: "swapDownReceipt(_: WBReceipt)", parameterMatchers: matchers))
	    }
	    
	    func titleSubtitle() -> Cuckoo.ClassStubFunction<(), TitleSubtitle> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptsInteractor.self, method: "titleSubtitle() -> TitleSubtitle", parameterMatchers: matchers))
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
	    
	    var scanService: Cuckoo.VerifyProperty<ScanService?> {
	        return .init(manager: cuckoo_manager, name: "scanService", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
	    
	    @discardableResult
	    func titleSubtitle() -> Cuckoo.__DoNotUse<TitleSubtitle> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("titleSubtitle() -> TitleSubtitle", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
    
     override var scanService: ScanService! {
        get {
            return DefaultValueRegistry.defaultValue(for: (ScanService!).self)
        }
        
        set { }
        
    }
    

    

    
     override func configureSubscribers()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func distanceReceipts()  -> [WBReceipt] {
        return DefaultValueRegistry.defaultValue(for: [WBReceipt].self)
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
    
     override func titleSubtitle()  -> TitleSubtitle {
        return DefaultValueRegistry.defaultValue(for: TitleSubtitle.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipts/ReceiptsPresenter.swift
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

class MockReceiptsPresenter: ReceiptsPresenter, Cuckoo.ClassMock {
    typealias MocksType = ReceiptsPresenter
    typealias Stubbing = __StubbingProxy_ReceiptsPresenter
    typealias Verification = __VerificationProxy_ReceiptsPresenter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "scanService", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "ScanService", "isReadOnly": true, "accessibility": ""]
     override var scanService: ScanService {
        get {
            
            return cuckoo_manager.getter("scanService", superclassCall: super.scanService)
            
        }
        
    }
    

    

    
    // ["name": "viewHasLoaded", "returnSignature": "", "fullyQualifiedName": "viewHasLoaded()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func viewHasLoaded()  {
        
            return cuckoo_manager.call("viewHasLoaded()",
                parameters: (),
                superclassCall:
                    
                    super.viewHasLoaded()
                    )
        
    }
    
    // ["name": "setupView", "returnSignature": "", "fullyQualifiedName": "setupView(data: Any)", "parameterSignature": "data: Any", "parameterSignatureWithoutNames": "data: Any", "inputTypes": "Any", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "data", "call": "data: data", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("data"), name: "data", type: "Any", range: CountableRange(2100..<2109), nameRange: CountableRange(2100..<2104))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func setupView(data: Any)  {
        
            return cuckoo_manager.call("setupView(data: Any)",
                parameters: (data),
                superclassCall:
                    
                    super.setupView(data: data)
                    )
        
    }
    
    // ["name": "presentAttachment", "returnSignature": "", "fullyQualifiedName": "presentAttachment(for: WBReceipt)", "parameterSignature": "for receipt: WBReceipt", "parameterSignatureWithoutNames": "receipt: WBReceipt", "inputTypes": "WBReceipt", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "receipt", "call": "for: receipt", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("for"), name: "receipt", type: "WBReceipt", range: CountableRange(2829..<2851), nameRange: CountableRange(2829..<2832))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func presentAttachment(for receipt: WBReceipt)  {
        
            return cuckoo_manager.call("presentAttachment(for: WBReceipt)",
                parameters: (receipt),
                superclassCall:
                    
                    super.presentAttachment(for: receipt)
                    )
        
    }
    

	struct __StubbingProxy_ReceiptsPresenter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var scanService: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockReceiptsPresenter, ScanService> {
	        return .init(manager: cuckoo_manager, name: "scanService")
	    }
	    
	    
	    func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptsPresenter.self, method: "viewHasLoaded()", parameterMatchers: matchers))
	    }
	    
	    func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.ClassStubNoReturnFunction<(Any)> where M1.MatchedType == Any {
	        let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptsPresenter.self, method: "setupView(data: Any)", parameterMatchers: matchers))
	    }
	    
	    func presentAttachment<M1: Cuckoo.Matchable>(for receipt: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
	        let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptsPresenter.self, method: "presentAttachment(for: WBReceipt)", parameterMatchers: matchers))
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
	
	    
	    var scanService: Cuckoo.VerifyReadOnlyProperty<ScanService> {
	        return .init(manager: cuckoo_manager, name: "scanService", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
	    func presentAttachment<M1: Cuckoo.Matchable>(for receipt: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == WBReceipt {
	        let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
	        return cuckoo_manager.verify("presentAttachment(for: WBReceipt)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class ReceiptsPresenterStub: ReceiptsPresenter {
    
     override var scanService: ScanService {
        get {
            return DefaultValueRegistry.defaultValue(for: (ScanService).self)
        }
        
    }
    

    

    
     override func viewHasLoaded()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func setupView(data: Any)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func presentAttachment(for receipt: WBReceipt)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/Receipts/ReceiptsRouter.swift
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

class MockReceiptsRouter: ReceiptsRouter, Cuckoo.ClassMock {
    typealias MocksType = ReceiptsRouter
    typealias Stubbing = __StubbingProxy_ReceiptsRouter
    typealias Verification = __VerificationProxy_ReceiptsRouter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "moduleTrip", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "WBTrip!", "isReadOnly": false, "accessibility": ""]
     override var moduleTrip: WBTrip! {
        get {
            
            return cuckoo_manager.getter("moduleTrip", superclassCall: super.moduleTrip)
            
        }
        
        set {
            
            cuckoo_manager.setter("moduleTrip", value: newValue, superclassCall: super.moduleTrip = newValue)
            
        }
        
    }
    

    

    
    // ["name": "openDistances", "returnSignature": "", "fullyQualifiedName": "openDistances()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openDistances()  {
        
            return cuckoo_manager.call("openDistances()",
                parameters: (),
                superclassCall:
                    
                    super.openDistances()
                    )
        
    }
    
    // ["name": "openImageViewer", "returnSignature": "", "fullyQualifiedName": "openImageViewer(for: WBReceipt)", "parameterSignature": "for receipt: WBReceipt", "parameterSignatureWithoutNames": "receipt: WBReceipt", "inputTypes": "WBReceipt", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "receipt", "call": "for: receipt", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("for"), name: "receipt", type: "WBReceipt", range: CountableRange(802..<824), nameRange: CountableRange(802..<805))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openImageViewer(for receipt: WBReceipt)  {
        
            return cuckoo_manager.call("openImageViewer(for: WBReceipt)",
                parameters: (receipt),
                superclassCall:
                    
                    super.openImageViewer(for: receipt)
                    )
        
    }
    
    // ["name": "openPDFViewer", "returnSignature": "", "fullyQualifiedName": "openPDFViewer(for: WBReceipt)", "parameterSignature": "for receipt: WBReceipt", "parameterSignatureWithoutNames": "receipt: WBReceipt", "inputTypes": "WBReceipt", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "receipt", "call": "for: receipt", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("for"), name: "receipt", type: "WBReceipt", range: CountableRange(1206..<1228), nameRange: CountableRange(1206..<1209))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openPDFViewer(for receipt: WBReceipt)  {
        
            return cuckoo_manager.call("openPDFViewer(for: WBReceipt)",
                parameters: (receipt),
                superclassCall:
                    
                    super.openPDFViewer(for: receipt)
                    )
        
    }
    
    // ["name": "openGenerateReport", "returnSignature": "", "fullyQualifiedName": "openGenerateReport()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openGenerateReport()  {
        
            return cuckoo_manager.call("openGenerateReport()",
                parameters: (),
                superclassCall:
                    
                    super.openGenerateReport()
                    )
        
    }
    
    // ["name": "openCreateReceipt", "returnSignature": "", "fullyQualifiedName": "openCreateReceipt()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openCreateReceipt()  {
        
            return cuckoo_manager.call("openCreateReceipt()",
                parameters: (),
                superclassCall:
                    
                    super.openCreateReceipt()
                    )
        
    }
    
    // ["name": "openCreatePhotoReceipt", "returnSignature": "", "fullyQualifiedName": "openCreatePhotoReceipt()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openCreatePhotoReceipt()  {
        
            return cuckoo_manager.call("openCreatePhotoReceipt()",
                parameters: (),
                superclassCall:
                    
                    super.openCreatePhotoReceipt()
                    )
        
    }
    
    // ["name": "openImportReceiptFile", "returnSignature": "", "fullyQualifiedName": "openImportReceiptFile()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openImportReceiptFile()  {
        
            return cuckoo_manager.call("openImportReceiptFile()",
                parameters: (),
                superclassCall:
                    
                    super.openImportReceiptFile()
                    )
        
    }
    
    // ["name": "openActions", "returnSignature": " -> ReceiptActionsPresenter", "fullyQualifiedName": "openActions(receipt: WBReceipt) -> ReceiptActionsPresenter", "parameterSignature": "receipt: WBReceipt", "parameterSignatureWithoutNames": "receipt: WBReceipt", "inputTypes": "WBReceipt", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "receipt", "call": "receipt: receipt", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("receipt"), name: "receipt", type: "WBReceipt", range: CountableRange(3876..<3894), nameRange: CountableRange(3876..<3883))], "returnType": "ReceiptActionsPresenter", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func openActions(receipt: WBReceipt)  -> ReceiptActionsPresenter {
        
            return cuckoo_manager.call("openActions(receipt: WBReceipt) -> ReceiptActionsPresenter",
                parameters: (receipt),
                superclassCall:
                    
                    super.openActions(receipt: receipt)
                    )
        
    }
    
    // ["name": "openEdit", "returnSignature": "", "fullyQualifiedName": "openEdit(receipt: WBReceipt)", "parameterSignature": "receipt: WBReceipt", "parameterSignatureWithoutNames": "receipt: WBReceipt", "inputTypes": "WBReceipt", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "receipt", "call": "receipt: receipt", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("receipt"), name: "receipt", type: "WBReceipt", range: CountableRange(4324..<4342), nameRange: CountableRange(4324..<4331))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openEdit(receipt: WBReceipt)  {
        
            return cuckoo_manager.call("openEdit(receipt: WBReceipt)",
                parameters: (receipt),
                superclassCall:
                    
                    super.openEdit(receipt: receipt)
                    )
        
    }
    

	struct __StubbingProxy_ReceiptsRouter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var moduleTrip: Cuckoo.ClassToBeStubbedProperty<MockReceiptsRouter, WBTrip?> {
	        return .init(manager: cuckoo_manager, name: "moduleTrip")
	    }
	    
	    
	    func openDistances() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptsRouter.self, method: "openDistances()", parameterMatchers: matchers))
	    }
	    
	    func openImageViewer<M1: Cuckoo.Matchable>(for receipt: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
	        let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptsRouter.self, method: "openImageViewer(for: WBReceipt)", parameterMatchers: matchers))
	    }
	    
	    func openPDFViewer<M1: Cuckoo.Matchable>(for receipt: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
	        let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptsRouter.self, method: "openPDFViewer(for: WBReceipt)", parameterMatchers: matchers))
	    }
	    
	    func openGenerateReport() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptsRouter.self, method: "openGenerateReport()", parameterMatchers: matchers))
	    }
	    
	    func openCreateReceipt() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptsRouter.self, method: "openCreateReceipt()", parameterMatchers: matchers))
	    }
	    
	    func openCreatePhotoReceipt() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptsRouter.self, method: "openCreatePhotoReceipt()", parameterMatchers: matchers))
	    }
	    
	    func openImportReceiptFile() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptsRouter.self, method: "openImportReceiptFile()", parameterMatchers: matchers))
	    }
	    
	    func openActions<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.ClassStubFunction<(WBReceipt), ReceiptActionsPresenter> where M1.MatchedType == WBReceipt {
	        let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptsRouter.self, method: "openActions(receipt: WBReceipt) -> ReceiptActionsPresenter", parameterMatchers: matchers))
	    }
	    
	    func openEdit<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBReceipt)> where M1.MatchedType == WBReceipt {
	        let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockReceiptsRouter.self, method: "openEdit(receipt: WBReceipt)", parameterMatchers: matchers))
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
	    func openImportReceiptFile() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("openImportReceiptFile()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func openActions<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.__DoNotUse<ReceiptActionsPresenter> where M1.MatchedType == WBReceipt {
	        let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
	        return cuckoo_manager.verify("openActions(receipt: WBReceipt) -> ReceiptActionsPresenter", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func openEdit<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == WBReceipt {
	        let matchers: [Cuckoo.ParameterMatcher<(WBReceipt)>] = [wrap(matchable: receipt) { $0 }]
	        return cuckoo_manager.verify("openEdit(receipt: WBReceipt)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
    
     override func openImportReceiptFile()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openActions(receipt: WBReceipt)  -> ReceiptActionsPresenter {
        return DefaultValueRegistry.defaultValue(for: ReceiptActionsPresenter.self)
    }
    
     override func openEdit(receipt: WBReceipt)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/Trip Distances/TripDistancesInteractor.swift
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

class MockTripDistancesInteractor: TripDistancesInteractor, Cuckoo.ClassMock {
    typealias MocksType = TripDistancesInteractor
    typealias Stubbing = __StubbingProxy_TripDistancesInteractor
    typealias Verification = __VerificationProxy_TripDistancesInteractor
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "trip", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "WBTrip!", "isReadOnly": false, "accessibility": ""]
     override var trip: WBTrip! {
        get {
            
            return cuckoo_manager.getter("trip", superclassCall: super.trip)
            
        }
        
        set {
            
            cuckoo_manager.setter("trip", value: newValue, superclassCall: super.trip = newValue)
            
        }
        
    }
    

    

    
    // ["name": "fetchedModelAdapter", "returnSignature": " -> FetchedModelAdapter", "fullyQualifiedName": "fetchedModelAdapter(for: WBTrip) -> FetchedModelAdapter", "parameterSignature": "for trip: WBTrip", "parameterSignatureWithoutNames": "trip: WBTrip", "inputTypes": "WBTrip", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "trip", "call": "for: trip", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("for"), name: "trip", type: "WBTrip", range: CountableRange(487..<503), nameRange: CountableRange(487..<490))], "returnType": "FetchedModelAdapter", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func fetchedModelAdapter(for trip: WBTrip)  -> FetchedModelAdapter {
        
            return cuckoo_manager.call("fetchedModelAdapter(for: WBTrip) -> FetchedModelAdapter",
                parameters: (trip),
                superclassCall:
                    
                    super.fetchedModelAdapter(for: trip)
                    )
        
    }
    
    // ["name": "totalDistancePrice", "returnSignature": " -> String", "fullyQualifiedName": "totalDistancePrice() -> String", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "String", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func totalDistancePrice()  -> String {
        
            return cuckoo_manager.call("totalDistancePrice() -> String",
                parameters: (),
                superclassCall:
                    
                    super.totalDistancePrice()
                    )
        
    }
    
    // ["name": "delete", "returnSignature": "", "fullyQualifiedName": "delete(distance: Distance)", "parameterSignature": "distance: Distance", "parameterSignatureWithoutNames": "distance: Distance", "inputTypes": "Distance", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "distance", "call": "distance: distance", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("distance"), name: "distance", type: "Distance", range: CountableRange(1368..<1386), nameRange: CountableRange(1368..<1376))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func delete(distance: Distance)  {
        
            return cuckoo_manager.call("delete(distance: Distance)",
                parameters: (distance),
                superclassCall:
                    
                    super.delete(distance: distance)
                    )
        
    }
    

	struct __StubbingProxy_TripDistancesInteractor: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var trip: Cuckoo.ClassToBeStubbedProperty<MockTripDistancesInteractor, WBTrip?> {
	        return .init(manager: cuckoo_manager, name: "trip")
	    }
	    
	    
	    func fetchedModelAdapter<M1: Cuckoo.Matchable>(for trip: M1) -> Cuckoo.ClassStubFunction<(WBTrip), FetchedModelAdapter> where M1.MatchedType == WBTrip {
	        let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTripDistancesInteractor.self, method: "fetchedModelAdapter(for: WBTrip) -> FetchedModelAdapter", parameterMatchers: matchers))
	    }
	    
	    func totalDistancePrice() -> Cuckoo.ClassStubFunction<(), String> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTripDistancesInteractor.self, method: "totalDistancePrice() -> String", parameterMatchers: matchers))
	    }
	    
	    func delete<M1: Cuckoo.Matchable>(distance: M1) -> Cuckoo.ClassStubNoReturnFunction<(Distance)> where M1.MatchedType == Distance {
	        let matchers: [Cuckoo.ParameterMatcher<(Distance)>] = [wrap(matchable: distance) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTripDistancesInteractor.self, method: "delete(distance: Distance)", parameterMatchers: matchers))
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
	
	    
	    var trip: Cuckoo.VerifyProperty<WBTrip?> {
	        return .init(manager: cuckoo_manager, name: "trip", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func fetchedModelAdapter<M1: Cuckoo.Matchable>(for trip: M1) -> Cuckoo.__DoNotUse<FetchedModelAdapter> where M1.MatchedType == WBTrip {
	        let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
	        return cuckoo_manager.verify("fetchedModelAdapter(for: WBTrip) -> FetchedModelAdapter", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func totalDistancePrice() -> Cuckoo.__DoNotUse<String> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("totalDistancePrice() -> String", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func delete<M1: Cuckoo.Matchable>(distance: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Distance {
	        let matchers: [Cuckoo.ParameterMatcher<(Distance)>] = [wrap(matchable: distance) { $0 }]
	        return cuckoo_manager.verify("delete(distance: Distance)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class TripDistancesInteractorStub: TripDistancesInteractor {
    
     override var trip: WBTrip! {
        get {
            return DefaultValueRegistry.defaultValue(for: (WBTrip!).self)
        }
        
        set { }
        
    }
    

    

    
     override func fetchedModelAdapter(for trip: WBTrip)  -> FetchedModelAdapter {
        return DefaultValueRegistry.defaultValue(for: FetchedModelAdapter.self)
    }
    
     override func totalDistancePrice()  -> String {
        return DefaultValueRegistry.defaultValue(for: String.self)
    }
    
     override func delete(distance: Distance)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/Trip Distances/TripDistancesPresenter.swift
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
import RxSwift
import Viperit

class MockTripDistancesPresenter: TripDistancesPresenter, Cuckoo.ClassMock {
    typealias MocksType = TripDistancesPresenter
    typealias Stubbing = __StubbingProxy_TripDistancesPresenter
    typealias Verification = __VerificationProxy_TripDistancesPresenter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "fetchedModelAdapter", "returnSignature": " -> FetchedModelAdapter", "fullyQualifiedName": "fetchedModelAdapter(for: WBTrip) -> FetchedModelAdapter", "parameterSignature": "for trip: WBTrip", "parameterSignatureWithoutNames": "trip: WBTrip", "inputTypes": "WBTrip", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "trip", "call": "for: trip", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("for"), name: "trip", type: "WBTrip", range: CountableRange(341..<357), nameRange: CountableRange(341..<344))], "returnType": "FetchedModelAdapter", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func fetchedModelAdapter(for trip: WBTrip)  -> FetchedModelAdapter {
        
            return cuckoo_manager.call("fetchedModelAdapter(for: WBTrip) -> FetchedModelAdapter",
                parameters: (trip),
                superclassCall:
                    
                    super.fetchedModelAdapter(for: trip)
                    )
        
    }
    
    // ["name": "delete", "returnSignature": "", "fullyQualifiedName": "delete(distance: Distance)", "parameterSignature": "distance: Distance", "parameterSignatureWithoutNames": "distance: Distance", "inputTypes": "Distance", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "distance", "call": "distance: distance", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("distance"), name: "distance", type: "Distance", range: CountableRange(468..<486), nameRange: CountableRange(468..<476))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func delete(distance: Distance)  {
        
            return cuckoo_manager.call("delete(distance: Distance)",
                parameters: (distance),
                superclassCall:
                    
                    super.delete(distance: distance)
                    )
        
    }
    
    // ["name": "presentEditDistance", "returnSignature": "", "fullyQualifiedName": "presentEditDistance(with: Any?)", "parameterSignature": "with data: Any?", "parameterSignatureWithoutNames": "data: Any?", "inputTypes": "Any?", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "data", "call": "with: data", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("with"), name: "data", type: "Any?", range: CountableRange(576..<591), nameRange: CountableRange(576..<580))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func presentEditDistance(with data: Any?)  {
        
            return cuckoo_manager.call("presentEditDistance(with: Any?)",
                parameters: (data),
                superclassCall:
                    
                    super.presentEditDistance(with: data)
                    )
        
    }
    
    // ["name": "totalDistancePrice", "returnSignature": " -> String", "fullyQualifiedName": "totalDistancePrice() -> String", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "String", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func totalDistancePrice()  -> String {
        
            return cuckoo_manager.call("totalDistancePrice() -> String",
                parameters: (),
                superclassCall:
                    
                    super.totalDistancePrice()
                    )
        
    }
    
    // ["name": "setupView", "returnSignature": "", "fullyQualifiedName": "setupView(data: Any)", "parameterSignature": "data: Any", "parameterSignatureWithoutNames": "data: Any", "inputTypes": "Any", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "data", "call": "data: data", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("data"), name: "data", type: "Any", range: CountableRange(778..<787), nameRange: CountableRange(778..<782))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func setupView(data: Any)  {
        
            return cuckoo_manager.call("setupView(data: Any)",
                parameters: (data),
                superclassCall:
                    
                    super.setupView(data: data)
                    )
        
    }
    

	struct __StubbingProxy_TripDistancesPresenter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func fetchedModelAdapter<M1: Cuckoo.Matchable>(for trip: M1) -> Cuckoo.ClassStubFunction<(WBTrip), FetchedModelAdapter> where M1.MatchedType == WBTrip {
	        let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTripDistancesPresenter.self, method: "fetchedModelAdapter(for: WBTrip) -> FetchedModelAdapter", parameterMatchers: matchers))
	    }
	    
	    func delete<M1: Cuckoo.Matchable>(distance: M1) -> Cuckoo.ClassStubNoReturnFunction<(Distance)> where M1.MatchedType == Distance {
	        let matchers: [Cuckoo.ParameterMatcher<(Distance)>] = [wrap(matchable: distance) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTripDistancesPresenter.self, method: "delete(distance: Distance)", parameterMatchers: matchers))
	    }
	    
	    func presentEditDistance<M1: Cuckoo.Matchable>(with data: M1) -> Cuckoo.ClassStubNoReturnFunction<(Any?)> where M1.MatchedType == Any? {
	        let matchers: [Cuckoo.ParameterMatcher<(Any?)>] = [wrap(matchable: data) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTripDistancesPresenter.self, method: "presentEditDistance(with: Any?)", parameterMatchers: matchers))
	    }
	    
	    func totalDistancePrice() -> Cuckoo.ClassStubFunction<(), String> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTripDistancesPresenter.self, method: "totalDistancePrice() -> String", parameterMatchers: matchers))
	    }
	    
	    func setupView<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.ClassStubNoReturnFunction<(Any)> where M1.MatchedType == Any {
	        let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: data) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTripDistancesPresenter.self, method: "setupView(data: Any)", parameterMatchers: matchers))
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
	    func totalDistancePrice() -> Cuckoo.__DoNotUse<String> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("totalDistancePrice() -> String", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
    
     override func totalDistancePrice()  -> String {
        return DefaultValueRegistry.defaultValue(for: String.self)
    }
    
     override func setupView(data: Any)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/Trips/TripsInteractor.swift
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

class MockTripsInteractor: TripsInteractor, Cuckoo.ClassMock {
    typealias MocksType = TripsInteractor
    typealias Stubbing = __StubbingProxy_TripsInteractor
    typealias Verification = __VerificationProxy_TripsInteractor
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "lastOpenedTrip", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Observable<WBTrip>", "isReadOnly": true, "accessibility": ""]
     override var lastOpenedTrip: Observable<WBTrip> {
        get {
            
            return cuckoo_manager.getter("lastOpenedTrip", superclassCall: super.lastOpenedTrip)
            
        }
        
    }
    

    

    
    // ["name": "configureSubscribers", "returnSignature": "", "fullyQualifiedName": "configureSubscribers()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func configureSubscribers()  {
        
            return cuckoo_manager.call("configureSubscribers()",
                parameters: (),
                superclassCall:
                    
                    super.configureSubscribers()
                    )
        
    }
    
    // ["name": "fetchedModelAdapter", "returnSignature": " -> FetchedModelAdapter?", "fullyQualifiedName": "fetchedModelAdapter() -> FetchedModelAdapter?", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Optional<FetchedModelAdapter>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        
            return cuckoo_manager.call("fetchedModelAdapter() -> FetchedModelAdapter?",
                parameters: (),
                superclassCall:
                    
                    super.fetchedModelAdapter()
                    )
        
    }
    
    // ["name": "markLastOpened", "returnSignature": "", "fullyQualifiedName": "markLastOpened(trip: WBTrip)", "parameterSignature": "trip: WBTrip", "parameterSignatureWithoutNames": "trip: WBTrip", "inputTypes": "WBTrip", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "trip", "call": "trip: trip", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("trip"), name: "trip", type: "WBTrip", range: CountableRange(750..<762), nameRange: CountableRange(750..<754))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func markLastOpened(trip: WBTrip)  {
        
            return cuckoo_manager.call("markLastOpened(trip: WBTrip)",
                parameters: (trip),
                superclassCall:
                    
                    super.markLastOpened(trip: trip)
                    )
        
    }
    

	struct __StubbingProxy_TripsInteractor: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var lastOpenedTrip: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockTripsInteractor, Observable<WBTrip>> {
	        return .init(manager: cuckoo_manager, name: "lastOpenedTrip")
	    }
	    
	    
	    func configureSubscribers() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTripsInteractor.self, method: "configureSubscribers()", parameterMatchers: matchers))
	    }
	    
	    func fetchedModelAdapter() -> Cuckoo.ClassStubFunction<(), Optional<FetchedModelAdapter>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTripsInteractor.self, method: "fetchedModelAdapter() -> FetchedModelAdapter?", parameterMatchers: matchers))
	    }
	    
	    func markLastOpened<M1: Cuckoo.Matchable>(trip: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBTrip)> where M1.MatchedType == WBTrip {
	        let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTripsInteractor.self, method: "markLastOpened(trip: WBTrip)", parameterMatchers: matchers))
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
	
	    
	    var lastOpenedTrip: Cuckoo.VerifyReadOnlyProperty<Observable<WBTrip>> {
	        return .init(manager: cuckoo_manager, name: "lastOpenedTrip", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
	    func markLastOpened<M1: Cuckoo.Matchable>(trip: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == WBTrip {
	        let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
	        return cuckoo_manager.verify("markLastOpened(trip: WBTrip)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class TripsInteractorStub: TripsInteractor {
    
     override var lastOpenedTrip: Observable<WBTrip> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Observable<WBTrip>).self)
        }
        
    }
    

    

    
     override func configureSubscribers()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        return DefaultValueRegistry.defaultValue(for: Optional<FetchedModelAdapter>.self)
    }
    
     override func markLastOpened(trip: WBTrip)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Modules/Trips/TripsPresenter.swift
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
import UserNotifications
import Viperit

class MockTripsPresenter: TripsPresenter, Cuckoo.ClassMock {
    typealias MocksType = TripsPresenter
    typealias Stubbing = __StubbingProxy_TripsPresenter
    typealias Verification = __VerificationProxy_TripsPresenter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "viewHasLoaded", "returnSignature": "", "fullyQualifiedName": "viewHasLoaded()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func viewHasLoaded()  {
        
            return cuckoo_manager.call("viewHasLoaded()",
                parameters: (),
                superclassCall:
                    
                    super.viewHasLoaded()
                    )
        
    }
    
    // ["name": "presentSettings", "returnSignature": "", "fullyQualifiedName": "presentSettings()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func presentSettings()  {
        
            return cuckoo_manager.call("presentSettings()",
                parameters: (),
                superclassCall:
                    
                    super.presentSettings()
                    )
        
    }
    
    // ["name": "presentAddTrip", "returnSignature": "", "fullyQualifiedName": "presentAddTrip()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func presentAddTrip()  {
        
            return cuckoo_manager.call("presentAddTrip()",
                parameters: (),
                superclassCall:
                    
                    super.presentAddTrip()
                    )
        
    }
    
    // ["name": "fetchedModelAdapter", "returnSignature": " -> FetchedModelAdapter?", "fullyQualifiedName": "fetchedModelAdapter() -> FetchedModelAdapter?", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Optional<FetchedModelAdapter>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func fetchedModelAdapter()  -> FetchedModelAdapter? {
        
            return cuckoo_manager.call("fetchedModelAdapter() -> FetchedModelAdapter?",
                parameters: (),
                superclassCall:
                    
                    super.fetchedModelAdapter()
                    )
        
    }
    

	struct __StubbingProxy_TripsPresenter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func viewHasLoaded() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTripsPresenter.self, method: "viewHasLoaded()", parameterMatchers: matchers))
	    }
	    
	    func presentSettings() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTripsPresenter.self, method: "presentSettings()", parameterMatchers: matchers))
	    }
	    
	    func presentAddTrip() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTripsPresenter.self, method: "presentAddTrip()", parameterMatchers: matchers))
	    }
	    
	    func fetchedModelAdapter() -> Cuckoo.ClassStubFunction<(), Optional<FetchedModelAdapter>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTripsPresenter.self, method: "fetchedModelAdapter() -> FetchedModelAdapter?", parameterMatchers: matchers))
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


// MARK: - Mocks generated from file: SmartReceipts/Modules/Trips/TripsRouter.swift
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
import SafariServices
import Viperit

class MockTripsRouter: TripsRouter, Cuckoo.ClassMock {
    typealias MocksType = TripsRouter
    typealias Stubbing = __StubbingProxy_TripsRouter
    typealias Verification = __VerificationProxy_TripsRouter
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "openSettings", "returnSignature": "", "fullyQualifiedName": "openSettings()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openSettings()  {
        
            return cuckoo_manager.call("openSettings()",
                parameters: (),
                superclassCall:
                    
                    super.openSettings()
                    )
        
    }
    
    // ["name": "openPrivacySettings", "returnSignature": "", "fullyQualifiedName": "openPrivacySettings()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openPrivacySettings()  {
        
            return cuckoo_manager.call("openPrivacySettings()",
                parameters: (),
                superclassCall:
                    
                    super.openPrivacySettings()
                    )
        
    }
    
    // ["name": "openBackup", "returnSignature": "", "fullyQualifiedName": "openBackup()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openBackup()  {
        
            return cuckoo_manager.call("openBackup()",
                parameters: (),
                superclassCall:
                    
                    super.openBackup()
                    )
        
    }
    
    // ["name": "openDebug", "returnSignature": "", "fullyQualifiedName": "openDebug()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openDebug()  {
        
            return cuckoo_manager.call("openDebug()",
                parameters: (),
                superclassCall:
                    
                    super.openDebug()
                    )
        
    }
    
    // ["name": "openAuth", "returnSignature": " -> AuthModuleInterface", "fullyQualifiedName": "openAuth() -> AuthModuleInterface", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "AuthModuleInterface", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func openAuth()  -> AuthModuleInterface {
        
            return cuckoo_manager.call("openAuth() -> AuthModuleInterface",
                parameters: (),
                superclassCall:
                    
                    super.openAuth()
                    )
        
    }
    
    // ["name": "openAutoScans", "returnSignature": "", "fullyQualifiedName": "openAutoScans()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openAutoScans()  {
        
            return cuckoo_manager.call("openAutoScans()",
                parameters: (),
                superclassCall:
                    
                    super.openAutoScans()
                    )
        
    }
    
    // ["name": "openUserGuide", "returnSignature": "", "fullyQualifiedName": "openUserGuide()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openUserGuide()  {
        
            return cuckoo_manager.call("openUserGuide()",
                parameters: (),
                superclassCall:
                    
                    super.openUserGuide()
                    )
        
    }
    
    // ["name": "openEdit", "returnSignature": "", "fullyQualifiedName": "openEdit(trip: WBTrip)", "parameterSignature": "trip: WBTrip", "parameterSignatureWithoutNames": "trip: WBTrip", "inputTypes": "WBTrip", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "trip", "call": "trip: trip", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("trip"), name: "trip", type: "WBTrip", range: CountableRange(1669..<1681), nameRange: CountableRange(1669..<1673))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openEdit(trip: WBTrip)  {
        
            return cuckoo_manager.call("openEdit(trip: WBTrip)",
                parameters: (trip),
                superclassCall:
                    
                    super.openEdit(trip: trip)
                    )
        
    }
    
    // ["name": "openAddTrip", "returnSignature": "", "fullyQualifiedName": "openAddTrip()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openAddTrip()  {
        
            return cuckoo_manager.call("openAddTrip()",
                parameters: (),
                superclassCall:
                    
                    super.openAddTrip()
                    )
        
    }
    
    // ["name": "openDetails", "returnSignature": "", "fullyQualifiedName": "openDetails(trip: WBTrip)", "parameterSignature": "trip: WBTrip", "parameterSignatureWithoutNames": "trip: WBTrip", "inputTypes": "WBTrip", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "trip", "call": "trip: trip", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("trip"), name: "trip", type: "WBTrip", range: CountableRange(1806..<1818), nameRange: CountableRange(1806..<1810))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openDetails(trip: WBTrip)  {
        
            return cuckoo_manager.call("openDetails(trip: WBTrip)",
                parameters: (trip),
                superclassCall:
                    
                    super.openDetails(trip: trip)
                    )
        
    }
    
    // ["name": "openNoTrips", "returnSignature": "", "fullyQualifiedName": "openNoTrips()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func openNoTrips()  {
        
            return cuckoo_manager.call("openNoTrips()",
                parameters: (),
                superclassCall:
                    
                    super.openNoTrips()
                    )
        
    }
    

	struct __StubbingProxy_TripsRouter: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func openSettings() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTripsRouter.self, method: "openSettings()", parameterMatchers: matchers))
	    }
	    
	    func openPrivacySettings() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTripsRouter.self, method: "openPrivacySettings()", parameterMatchers: matchers))
	    }
	    
	    func openBackup() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTripsRouter.self, method: "openBackup()", parameterMatchers: matchers))
	    }
	    
	    func openDebug() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTripsRouter.self, method: "openDebug()", parameterMatchers: matchers))
	    }
	    
	    func openAuth() -> Cuckoo.ClassStubFunction<(), AuthModuleInterface> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTripsRouter.self, method: "openAuth() -> AuthModuleInterface", parameterMatchers: matchers))
	    }
	    
	    func openAutoScans() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTripsRouter.self, method: "openAutoScans()", parameterMatchers: matchers))
	    }
	    
	    func openUserGuide() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTripsRouter.self, method: "openUserGuide()", parameterMatchers: matchers))
	    }
	    
	    func openEdit<M1: Cuckoo.Matchable>(trip: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBTrip)> where M1.MatchedType == WBTrip {
	        let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTripsRouter.self, method: "openEdit(trip: WBTrip)", parameterMatchers: matchers))
	    }
	    
	    func openAddTrip() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTripsRouter.self, method: "openAddTrip()", parameterMatchers: matchers))
	    }
	    
	    func openDetails<M1: Cuckoo.Matchable>(trip: M1) -> Cuckoo.ClassStubNoReturnFunction<(WBTrip)> where M1.MatchedType == WBTrip {
	        let matchers: [Cuckoo.ParameterMatcher<(WBTrip)>] = [wrap(matchable: trip) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTripsRouter.self, method: "openDetails(trip: WBTrip)", parameterMatchers: matchers))
	    }
	    
	    func openNoTrips() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTripsRouter.self, method: "openNoTrips()", parameterMatchers: matchers))
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
	    func openPrivacySettings() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("openPrivacySettings()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func openBackup() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("openBackup()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func openDebug() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("openDebug()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func openAuth() -> Cuckoo.__DoNotUse<AuthModuleInterface> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("openAuth() -> AuthModuleInterface", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func openAutoScans() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("openAutoScans()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func openUserGuide() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("openUserGuide()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
    
     override func openPrivacySettings()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openBackup()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openDebug()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openAuth()  -> AuthModuleInterface {
        return DefaultValueRegistry.defaultValue(for: AuthModuleInterface.self)
    }
    
     override func openAutoScans()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func openUserGuide()  {
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


// MARK: - Mocks generated from file: SmartReceipts/Services/Common/PurchaseService.swift
//
//  PurchaseService.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 02/10/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Moya
import RxSwift
import StoreKit
import SwiftyStoreKit

class MockPurchaseService: PurchaseService, Cuckoo.ClassMock {
    typealias MocksType = PurchaseService
    typealias Stubbing = __StubbingProxy_PurchaseService
    typealias Verification = __VerificationProxy_PurchaseService
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "cacheProducts", "returnSignature": "", "fullyQualifiedName": "cacheProducts()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func cacheProducts()  {
        
            return cuckoo_manager.call("cacheProducts()",
                parameters: (),
                superclassCall:
                    
                    super.cacheProducts()
                    )
        
    }
    
    // ["name": "requestProducts", "returnSignature": " -> Observable<SKProduct>", "fullyQualifiedName": "requestProducts() -> Observable<SKProduct>", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Observable<SKProduct>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func requestProducts()  -> Observable<SKProduct> {
        
            return cuckoo_manager.call("requestProducts() -> Observable<SKProduct>",
                parameters: (),
                superclassCall:
                    
                    super.requestProducts()
                    )
        
    }
    
    // ["name": "restorePurchases", "returnSignature": " -> Observable<[Purchase]>", "fullyQualifiedName": "restorePurchases() -> Observable<[Purchase]>", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Observable<[Purchase]>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func restorePurchases()  -> Observable<[Purchase]> {
        
            return cuckoo_manager.call("restorePurchases() -> Observable<[Purchase]>",
                parameters: (),
                superclassCall:
                    
                    super.restorePurchases()
                    )
        
    }
    
    // ["name": "restoreSubscription", "returnSignature": " -> Observable<Bool>", "fullyQualifiedName": "restoreSubscription() -> Observable<Bool>", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Observable<Bool>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func restoreSubscription()  -> Observable<Bool> {
        
            return cuckoo_manager.call("restoreSubscription() -> Observable<Bool>",
                parameters: (),
                superclassCall:
                    
                    super.restoreSubscription()
                    )
        
    }
    
    // ["name": "purchaseSubscription", "returnSignature": " -> Observable<PurchaseDetails>", "fullyQualifiedName": "purchaseSubscription() -> Observable<PurchaseDetails>", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Observable<PurchaseDetails>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func purchaseSubscription()  -> Observable<PurchaseDetails> {
        
            return cuckoo_manager.call("purchaseSubscription() -> Observable<PurchaseDetails>",
                parameters: (),
                superclassCall:
                    
                    super.purchaseSubscription()
                    )
        
    }
    
    // ["name": "purchase", "returnSignature": " -> Observable<PurchaseDetails>", "fullyQualifiedName": "purchase(prodcutID: String) -> Observable<PurchaseDetails>", "parameterSignature": "prodcutID: String", "parameterSignatureWithoutNames": "prodcutID: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "prodcutID", "call": "prodcutID: prodcutID", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("prodcutID"), name: "prodcutID", type: "String", range: CountableRange(5856..<5873), nameRange: CountableRange(5856..<5865))], "returnType": "Observable<PurchaseDetails>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func purchase(prodcutID: String)  -> Observable<PurchaseDetails> {
        
            return cuckoo_manager.call("purchase(prodcutID: String) -> Observable<PurchaseDetails>",
                parameters: (prodcutID),
                superclassCall:
                    
                    super.purchase(prodcutID: prodcutID)
                    )
        
    }
    
    // ["name": "price", "returnSignature": " -> Observable<String>", "fullyQualifiedName": "price(productID: String) -> Observable<String>", "parameterSignature": "productID: String", "parameterSignatureWithoutNames": "productID: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "productID", "call": "productID: productID", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("productID"), name: "productID", type: "String", range: CountableRange(7867..<7884), nameRange: CountableRange(7867..<7876))], "returnType": "Observable<String>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func price(productID: String)  -> Observable<String> {
        
            return cuckoo_manager.call("price(productID: String) -> Observable<String>",
                parameters: (productID),
                superclassCall:
                    
                    super.price(productID: productID)
                    )
        
    }
    
    // ["name": "completeTransactions", "returnSignature": "", "fullyQualifiedName": "completeTransactions()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func completeTransactions()  {
        
            return cuckoo_manager.call("completeTransactions()",
                parameters: (),
                superclassCall:
                    
                    super.completeTransactions()
                    )
        
    }
    
    // ["name": "appStoreReceipt", "returnSignature": " -> String?", "fullyQualifiedName": "appStoreReceipt() -> String?", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Optional<String>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func appStoreReceipt()  -> String? {
        
            return cuckoo_manager.call("appStoreReceipt() -> String?",
                parameters: (),
                superclassCall:
                    
                    super.appStoreReceipt()
                    )
        
    }
    
    // ["name": "isReceiptSent", "returnSignature": " -> Bool", "fullyQualifiedName": "isReceiptSent(_: String) -> Bool", "parameterSignature": "_ receipt: String", "parameterSignatureWithoutNames": "receipt: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "receipt", "call": "receipt", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "receipt", type: "String", range: CountableRange(9650..<9667), nameRange: CountableRange(0..<0))], "returnType": "Bool", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func isReceiptSent(_ receipt: String)  -> Bool {
        
            return cuckoo_manager.call("isReceiptSent(_: String) -> Bool",
                parameters: (receipt),
                superclassCall:
                    
                    super.isReceiptSent(receipt)
                    )
        
    }
    
    // ["name": "logPurchases", "returnSignature": "", "fullyQualifiedName": "logPurchases()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func logPurchases()  {
        
            return cuckoo_manager.call("logPurchases()",
                parameters: (),
                superclassCall:
                    
                    super.logPurchases()
                    )
        
    }
    
    // ["name": "sendReceipt", "returnSignature": "", "fullyQualifiedName": "sendReceipt()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func sendReceipt()  {
        
            return cuckoo_manager.call("sendReceipt()",
                parameters: (),
                superclassCall:
                    
                    super.sendReceipt()
                    )
        
    }
    
    // ["name": "resetCache", "returnSignature": "", "fullyQualifiedName": "resetCache()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func resetCache()  {
        
            return cuckoo_manager.call("resetCache()",
                parameters: (),
                superclassCall:
                    
                    super.resetCache()
                    )
        
    }
    
    // ["name": "cacheSubscriptionValidation", "returnSignature": "", "fullyQualifiedName": "cacheSubscriptionValidation()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func cacheSubscriptionValidation()  {
        
            return cuckoo_manager.call("cacheSubscriptionValidation()",
                parameters: (),
                superclassCall:
                    
                    super.cacheSubscriptionValidation()
                    )
        
    }
    
    // ["name": "hasValidSubscription", "returnSignature": " -> Observable<Bool>", "fullyQualifiedName": "hasValidSubscription() -> Observable<Bool>", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Observable<Bool>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func hasValidSubscription()  -> Observable<Bool> {
        
            return cuckoo_manager.call("hasValidSubscription() -> Observable<Bool>",
                parameters: (),
                superclassCall:
                    
                    super.hasValidSubscription()
                    )
        
    }
    
    // ["name": "subscriptionExpirationDate", "returnSignature": " -> Observable<Date?>", "fullyQualifiedName": "subscriptionExpirationDate() -> Observable<Date?>", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Observable<Date?>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func subscriptionExpirationDate()  -> Observable<Date?> {
        
            return cuckoo_manager.call("subscriptionExpirationDate() -> Observable<Date?>",
                parameters: (),
                superclassCall:
                    
                    super.subscriptionExpirationDate()
                    )
        
    }
    
    // ["name": "validateSubscription", "returnSignature": " -> Observable<SubscriptionValidation>", "fullyQualifiedName": "validateSubscription() -> Observable<SubscriptionValidation>", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Observable<SubscriptionValidation>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func validateSubscription()  -> Observable<SubscriptionValidation> {
        
            return cuckoo_manager.call("validateSubscription() -> Observable<SubscriptionValidation>",
                parameters: (),
                superclassCall:
                    
                    super.validateSubscription()
                    )
        
    }
    
    // ["name": "forceValidateSubscription", "returnSignature": " -> Observable<SubscriptionValidation>", "fullyQualifiedName": "forceValidateSubscription() -> Observable<SubscriptionValidation>", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Observable<SubscriptionValidation>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func forceValidateSubscription()  -> Observable<SubscriptionValidation> {
        
            return cuckoo_manager.call("forceValidateSubscription() -> Observable<SubscriptionValidation>",
                parameters: (),
                superclassCall:
                    
                    super.forceValidateSubscription()
                    )
        
    }
    
    // ["name": "verifySubscription", "returnSignature": " -> VerifySubscriptionResult", "fullyQualifiedName": "verifySubscription(receipt: ReceiptInfo) -> VerifySubscriptionResult", "parameterSignature": "receipt: ReceiptInfo", "parameterSignatureWithoutNames": "receipt: ReceiptInfo", "inputTypes": "ReceiptInfo", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "receipt", "call": "receipt: receipt", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("receipt"), name: "receipt", type: "ReceiptInfo", range: CountableRange(15678..<15698), nameRange: CountableRange(15678..<15685))], "returnType": "VerifySubscriptionResult", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func verifySubscription(receipt: ReceiptInfo)  -> VerifySubscriptionResult {
        
            return cuckoo_manager.call("verifySubscription(receipt: ReceiptInfo) -> VerifySubscriptionResult",
                parameters: (receipt),
                superclassCall:
                    
                    super.verifySubscription(receipt: receipt)
                    )
        
    }
    
    // ["name": "markAppStoreInteracted", "returnSignature": "", "fullyQualifiedName": "markAppStoreInteracted()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func markAppStoreInteracted()  {
        
            return cuckoo_manager.call("markAppStoreInteracted()",
                parameters: (),
                superclassCall:
                    
                    super.markAppStoreInteracted()
                    )
        
    }
    
    // ["name": "isAppStoreInteracted", "returnSignature": " -> Bool", "fullyQualifiedName": "isAppStoreInteracted() -> Bool", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Bool", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func isAppStoreInteracted()  -> Bool {
        
            return cuckoo_manager.call("isAppStoreInteracted() -> Bool",
                parameters: (),
                superclassCall:
                    
                    super.isAppStoreInteracted()
                    )
        
    }
    

	struct __StubbingProxy_PurchaseService: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func cacheProducts() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "cacheProducts()", parameterMatchers: matchers))
	    }
	    
	    func requestProducts() -> Cuckoo.ClassStubFunction<(), Observable<SKProduct>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "requestProducts() -> Observable<SKProduct>", parameterMatchers: matchers))
	    }
	    
	    func restorePurchases() -> Cuckoo.ClassStubFunction<(), Observable<[Purchase]>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "restorePurchases() -> Observable<[Purchase]>", parameterMatchers: matchers))
	    }
	    
	    func restoreSubscription() -> Cuckoo.ClassStubFunction<(), Observable<Bool>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "restoreSubscription() -> Observable<Bool>", parameterMatchers: matchers))
	    }
	    
	    func purchaseSubscription() -> Cuckoo.ClassStubFunction<(), Observable<PurchaseDetails>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "purchaseSubscription() -> Observable<PurchaseDetails>", parameterMatchers: matchers))
	    }
	    
	    func purchase<M1: Cuckoo.Matchable>(prodcutID: M1) -> Cuckoo.ClassStubFunction<(String), Observable<PurchaseDetails>> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: prodcutID) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "purchase(prodcutID: String) -> Observable<PurchaseDetails>", parameterMatchers: matchers))
	    }
	    
	    func price<M1: Cuckoo.Matchable>(productID: M1) -> Cuckoo.ClassStubFunction<(String), Observable<String>> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: productID) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "price(productID: String) -> Observable<String>", parameterMatchers: matchers))
	    }
	    
	    func completeTransactions() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "completeTransactions()", parameterMatchers: matchers))
	    }
	    
	    func appStoreReceipt() -> Cuckoo.ClassStubFunction<(), Optional<String>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "appStoreReceipt() -> String?", parameterMatchers: matchers))
	    }
	    
	    func isReceiptSent<M1: Cuckoo.Matchable>(_ receipt: M1) -> Cuckoo.ClassStubFunction<(String), Bool> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: receipt) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "isReceiptSent(_: String) -> Bool", parameterMatchers: matchers))
	    }
	    
	    func logPurchases() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "logPurchases()", parameterMatchers: matchers))
	    }
	    
	    func sendReceipt() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "sendReceipt()", parameterMatchers: matchers))
	    }
	    
	    func resetCache() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "resetCache()", parameterMatchers: matchers))
	    }
	    
	    func cacheSubscriptionValidation() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "cacheSubscriptionValidation()", parameterMatchers: matchers))
	    }
	    
	    func hasValidSubscription() -> Cuckoo.ClassStubFunction<(), Observable<Bool>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "hasValidSubscription() -> Observable<Bool>", parameterMatchers: matchers))
	    }
	    
	    func subscriptionExpirationDate() -> Cuckoo.ClassStubFunction<(), Observable<Date?>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "subscriptionExpirationDate() -> Observable<Date?>", parameterMatchers: matchers))
	    }
	    
	    func validateSubscription() -> Cuckoo.ClassStubFunction<(), Observable<SubscriptionValidation>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "validateSubscription() -> Observable<SubscriptionValidation>", parameterMatchers: matchers))
	    }
	    
	    func forceValidateSubscription() -> Cuckoo.ClassStubFunction<(), Observable<SubscriptionValidation>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "forceValidateSubscription() -> Observable<SubscriptionValidation>", parameterMatchers: matchers))
	    }
	    
	    func verifySubscription<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.ClassStubFunction<(ReceiptInfo), VerifySubscriptionResult> where M1.MatchedType == ReceiptInfo {
	        let matchers: [Cuckoo.ParameterMatcher<(ReceiptInfo)>] = [wrap(matchable: receipt) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "verifySubscription(receipt: ReceiptInfo) -> VerifySubscriptionResult", parameterMatchers: matchers))
	    }
	    
	    func markAppStoreInteracted() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "markAppStoreInteracted()", parameterMatchers: matchers))
	    }
	    
	    func isAppStoreInteracted() -> Cuckoo.ClassStubFunction<(), Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPurchaseService.self, method: "isAppStoreInteracted() -> Bool", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_PurchaseService: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func cacheProducts() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("cacheProducts()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func requestProducts() -> Cuckoo.__DoNotUse<Observable<SKProduct>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("requestProducts() -> Observable<SKProduct>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func restorePurchases() -> Cuckoo.__DoNotUse<Observable<[Purchase]>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("restorePurchases() -> Observable<[Purchase]>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func restoreSubscription() -> Cuckoo.__DoNotUse<Observable<Bool>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("restoreSubscription() -> Observable<Bool>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func purchaseSubscription() -> Cuckoo.__DoNotUse<Observable<PurchaseDetails>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("purchaseSubscription() -> Observable<PurchaseDetails>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func purchase<M1: Cuckoo.Matchable>(prodcutID: M1) -> Cuckoo.__DoNotUse<Observable<PurchaseDetails>> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: prodcutID) { $0 }]
	        return cuckoo_manager.verify("purchase(prodcutID: String) -> Observable<PurchaseDetails>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func price<M1: Cuckoo.Matchable>(productID: M1) -> Cuckoo.__DoNotUse<Observable<String>> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: productID) { $0 }]
	        return cuckoo_manager.verify("price(productID: String) -> Observable<String>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func completeTransactions() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("completeTransactions()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func appStoreReceipt() -> Cuckoo.__DoNotUse<Optional<String>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("appStoreReceipt() -> String?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func isReceiptSent<M1: Cuckoo.Matchable>(_ receipt: M1) -> Cuckoo.__DoNotUse<Bool> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: receipt) { $0 }]
	        return cuckoo_manager.verify("isReceiptSent(_: String) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func logPurchases() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("logPurchases()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func sendReceipt() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("sendReceipt()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func resetCache() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("resetCache()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func cacheSubscriptionValidation() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("cacheSubscriptionValidation()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func hasValidSubscription() -> Cuckoo.__DoNotUse<Observable<Bool>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("hasValidSubscription() -> Observable<Bool>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func subscriptionExpirationDate() -> Cuckoo.__DoNotUse<Observable<Date?>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("subscriptionExpirationDate() -> Observable<Date?>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func validateSubscription() -> Cuckoo.__DoNotUse<Observable<SubscriptionValidation>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("validateSubscription() -> Observable<SubscriptionValidation>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func forceValidateSubscription() -> Cuckoo.__DoNotUse<Observable<SubscriptionValidation>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("forceValidateSubscription() -> Observable<SubscriptionValidation>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func verifySubscription<M1: Cuckoo.Matchable>(receipt: M1) -> Cuckoo.__DoNotUse<VerifySubscriptionResult> where M1.MatchedType == ReceiptInfo {
	        let matchers: [Cuckoo.ParameterMatcher<(ReceiptInfo)>] = [wrap(matchable: receipt) { $0 }]
	        return cuckoo_manager.verify("verifySubscription(receipt: ReceiptInfo) -> VerifySubscriptionResult", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func markAppStoreInteracted() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("markAppStoreInteracted()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func isAppStoreInteracted() -> Cuckoo.__DoNotUse<Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("isAppStoreInteracted() -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class PurchaseServiceStub: PurchaseService {
    

    

    
     override func cacheProducts()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func requestProducts()  -> Observable<SKProduct> {
        return DefaultValueRegistry.defaultValue(for: Observable<SKProduct>.self)
    }
    
     override func restorePurchases()  -> Observable<[Purchase]> {
        return DefaultValueRegistry.defaultValue(for: Observable<[Purchase]>.self)
    }
    
     override func restoreSubscription()  -> Observable<Bool> {
        return DefaultValueRegistry.defaultValue(for: Observable<Bool>.self)
    }
    
     override func purchaseSubscription()  -> Observable<PurchaseDetails> {
        return DefaultValueRegistry.defaultValue(for: Observable<PurchaseDetails>.self)
    }
    
     override func purchase(prodcutID: String)  -> Observable<PurchaseDetails> {
        return DefaultValueRegistry.defaultValue(for: Observable<PurchaseDetails>.self)
    }
    
     override func price(productID: String)  -> Observable<String> {
        return DefaultValueRegistry.defaultValue(for: Observable<String>.self)
    }
    
     override func completeTransactions()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func appStoreReceipt()  -> String? {
        return DefaultValueRegistry.defaultValue(for: Optional<String>.self)
    }
    
     override func isReceiptSent(_ receipt: String)  -> Bool {
        return DefaultValueRegistry.defaultValue(for: Bool.self)
    }
    
     override func logPurchases()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func sendReceipt()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func resetCache()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func cacheSubscriptionValidation()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func hasValidSubscription()  -> Observable<Bool> {
        return DefaultValueRegistry.defaultValue(for: Observable<Bool>.self)
    }
    
     override func subscriptionExpirationDate()  -> Observable<Date?> {
        return DefaultValueRegistry.defaultValue(for: Observable<Date?>.self)
    }
    
     override func validateSubscription()  -> Observable<SubscriptionValidation> {
        return DefaultValueRegistry.defaultValue(for: Observable<SubscriptionValidation>.self)
    }
    
     override func forceValidateSubscription()  -> Observable<SubscriptionValidation> {
        return DefaultValueRegistry.defaultValue(for: Observable<SubscriptionValidation>.self)
    }
    
     override func verifySubscription(receipt: ReceiptInfo)  -> VerifySubscriptionResult {
        return DefaultValueRegistry.defaultValue(for: VerifySubscriptionResult.self)
    }
    
     override func markAppStoreInteracted()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func isAppStoreInteracted()  -> Bool {
        return DefaultValueRegistry.defaultValue(for: Bool.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Services/Scan/RecognitionService.swift
//
//  RecognitionService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/11/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import Moya
import RxSwift

class MockRecognitionService: RecognitionService, Cuckoo.ClassMock {
    typealias MocksType = RecognitionService
    typealias Stubbing = __StubbingProxy_RecognitionService
    typealias Verification = __VerificationProxy_RecognitionService
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "getRecognition", "returnSignature": " -> Single<RecognitionResponse>", "fullyQualifiedName": "getRecognition(_: String) -> Single<RecognitionResponse>", "parameterSignature": "_ id: String", "parameterSignatureWithoutNames": "id: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "id", "call": "id", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "id", type: "String", range: CountableRange(413..<425), nameRange: CountableRange(0..<0))], "returnType": "Single<RecognitionResponse>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func getRecognition(_ id: String)  -> Single<RecognitionResponse> {
        
            return cuckoo_manager.call("getRecognition(_: String) -> Single<RecognitionResponse>",
                parameters: (id),
                superclassCall:
                    
                    super.getRecognition(id)
                    )
        
    }
    
    // ["name": "recognize", "returnSignature": " -> Single<String>", "fullyQualifiedName": "recognize(url: URL, incognito: Bool) -> Single<String>", "parameterSignature": "url: URL, incognito: Bool", "parameterSignatureWithoutNames": "url: URL, incognito: Bool", "inputTypes": "URL, Bool", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "url, incognito", "call": "url: url, incognito: incognito", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("url"), name: "url", type: "URL", range: CountableRange(598..<606), nameRange: CountableRange(598..<601)), CuckooGeneratorFramework.MethodParameter(label: Optional("incognito"), name: "incognito", type: "Bool", range: CountableRange(608..<631), nameRange: CountableRange(608..<617))], "returnType": "Single<String>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func recognize(url: URL, incognito: Bool)  -> Single<String> {
        
            return cuckoo_manager.call("recognize(url: URL, incognito: Bool) -> Single<String>",
                parameters: (url, incognito),
                superclassCall:
                    
                    super.recognize(url: url, incognito: incognito)
                    )
        
    }
    

	struct __StubbingProxy_RecognitionService: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func getRecognition<M1: Cuckoo.Matchable>(_ id: M1) -> Cuckoo.ClassStubFunction<(String), Single<RecognitionResponse>> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: id) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockRecognitionService.self, method: "getRecognition(_: String) -> Single<RecognitionResponse>", parameterMatchers: matchers))
	    }
	    
	    func recognize<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(url: M1, incognito: M2) -> Cuckoo.ClassStubFunction<(URL, Bool), Single<String>> where M1.MatchedType == URL, M2.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(URL, Bool)>] = [wrap(matchable: url) { $0.0 }, wrap(matchable: incognito) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockRecognitionService.self, method: "recognize(url: URL, incognito: Bool) -> Single<String>", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_RecognitionService: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func getRecognition<M1: Cuckoo.Matchable>(_ id: M1) -> Cuckoo.__DoNotUse<Single<RecognitionResponse>> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: id) { $0 }]
	        return cuckoo_manager.verify("getRecognition(_: String) -> Single<RecognitionResponse>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func recognize<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(url: M1, incognito: M2) -> Cuckoo.__DoNotUse<Single<String>> where M1.MatchedType == URL, M2.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(URL, Bool)>] = [wrap(matchable: url) { $0.0 }, wrap(matchable: incognito) { $0.1 }]
	        return cuckoo_manager.verify("recognize(url: URL, incognito: Bool) -> Single<String>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class RecognitionServiceStub: RecognitionService {
    

    

    
     override func getRecognition(_ id: String)  -> Single<RecognitionResponse> {
        return DefaultValueRegistry.defaultValue(for: Single<RecognitionResponse>.self)
    }
    
     override func recognize(url: URL, incognito: Bool)  -> Single<String> {
        return DefaultValueRegistry.defaultValue(for: Single<String>.self)
    }
    
}


// MARK: - Mocks generated from file: SmartReceipts/Services/Scan/S3Service.swift
//
//  S3Service.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 22/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Cuckoo
@testable import SmartReceipts

import AWSS3
import Foundation
import RxSwift

class MockS3Service: S3Service, Cuckoo.ClassMock {
    typealias MocksType = S3Service
    typealias Stubbing = __StubbingProxy_S3Service
    typealias Verification = __VerificationProxy_S3Service
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "upload", "returnSignature": " -> Observable<URL>", "fullyQualifiedName": "upload(image: UIImage) -> Observable<URL>", "parameterSignature": "image: UIImage", "parameterSignatureWithoutNames": "image: UIImage", "inputTypes": "UIImage", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "image", "call": "image: image", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("image"), name: "image", type: "UIImage", range: CountableRange(1194..<1208), nameRange: CountableRange(1194..<1199))], "returnType": "Observable<URL>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func upload(image: UIImage)  -> Observable<URL> {
        
            return cuckoo_manager.call("upload(image: UIImage) -> Observable<URL>",
                parameters: (image),
                superclassCall:
                    
                    super.upload(image: image)
                    )
        
    }
    
    // ["name": "upload", "returnSignature": " -> Observable<URL>", "fullyQualifiedName": "upload(file: URL) -> Observable<URL>", "parameterSignature": "file url: URL", "parameterSignatureWithoutNames": "url: URL", "inputTypes": "URL", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "url", "call": "file: url", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("file"), name: "url", type: "URL", range: CountableRange(1595..<1608), nameRange: CountableRange(1595..<1599))], "returnType": "Observable<URL>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func upload(file url: URL)  -> Observable<URL> {
        
            return cuckoo_manager.call("upload(file: URL) -> Observable<URL>",
                parameters: (url),
                superclassCall:
                    
                    super.upload(file: url)
                    )
        
    }
    
    // ["name": "downloadImage", "returnSignature": " -> Observable<UIImage>", "fullyQualifiedName": "downloadImage(_: URL, folder: String) -> Observable<UIImage>", "parameterSignature": "_ url: URL, folder: String", "parameterSignatureWithoutNames": "url: URL, folder: String", "inputTypes": "URL, String", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "url, folder", "call": "url, folder: folder", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "url", type: "URL", range: CountableRange(3003..<3013), nameRange: CountableRange(0..<0)), CuckooGeneratorFramework.MethodParameter(label: Optional("folder"), name: "folder", type: "String", range: CountableRange(3015..<3038), nameRange: CountableRange(3015..<3021))], "returnType": "Observable<UIImage>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func downloadImage(_ url: URL, folder: String)  -> Observable<UIImage> {
        
            return cuckoo_manager.call("downloadImage(_: URL, folder: String) -> Observable<UIImage>",
                parameters: (url, folder),
                superclassCall:
                    
                    super.downloadImage(url, folder: folder)
                    )
        
    }
    

	struct __StubbingProxy_S3Service: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func upload<M1: Cuckoo.Matchable>(image: M1) -> Cuckoo.ClassStubFunction<(UIImage), Observable<URL>> where M1.MatchedType == UIImage {
	        let matchers: [Cuckoo.ParameterMatcher<(UIImage)>] = [wrap(matchable: image) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockS3Service.self, method: "upload(image: UIImage) -> Observable<URL>", parameterMatchers: matchers))
	    }
	    
	    func upload<M1: Cuckoo.Matchable>(file url: M1) -> Cuckoo.ClassStubFunction<(URL), Observable<URL>> where M1.MatchedType == URL {
	        let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockS3Service.self, method: "upload(file: URL) -> Observable<URL>", parameterMatchers: matchers))
	    }
	    
	    func downloadImage<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ url: M1, folder: M2) -> Cuckoo.ClassStubFunction<(URL, String), Observable<UIImage>> where M1.MatchedType == URL, M2.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(URL, String)>] = [wrap(matchable: url) { $0.0 }, wrap(matchable: folder) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockS3Service.self, method: "downloadImage(_: URL, folder: String) -> Observable<UIImage>", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_S3Service: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func upload<M1: Cuckoo.Matchable>(image: M1) -> Cuckoo.__DoNotUse<Observable<URL>> where M1.MatchedType == UIImage {
	        let matchers: [Cuckoo.ParameterMatcher<(UIImage)>] = [wrap(matchable: image) { $0 }]
	        return cuckoo_manager.verify("upload(image: UIImage) -> Observable<URL>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func upload<M1: Cuckoo.Matchable>(file url: M1) -> Cuckoo.__DoNotUse<Observable<URL>> where M1.MatchedType == URL {
	        let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
	        return cuckoo_manager.verify("upload(file: URL) -> Observable<URL>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func downloadImage<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ url: M1, folder: M2) -> Cuckoo.__DoNotUse<Observable<UIImage>> where M1.MatchedType == URL, M2.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(URL, String)>] = [wrap(matchable: url) { $0.0 }, wrap(matchable: folder) { $0.1 }]
	        return cuckoo_manager.verify("downloadImage(_: URL, folder: String) -> Observable<UIImage>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class S3ServiceStub: S3Service {
    

    

    
     override func upload(image: UIImage)  -> Observable<URL> {
        return DefaultValueRegistry.defaultValue(for: Observable<URL>.self)
    }
    
     override func upload(file url: URL)  -> Observable<URL> {
        return DefaultValueRegistry.defaultValue(for: Observable<URL>.self)
    }
    
     override func downloadImage(_ url: URL, folder: String)  -> Observable<UIImage> {
        return DefaultValueRegistry.defaultValue(for: Observable<UIImage>.self)
    }
    
}

