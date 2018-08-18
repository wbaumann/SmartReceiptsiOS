//
//  FetchedModelAdapter+Rx.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 10/08/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift
import RxCocoa

typealias FetchedObjectAction = (object: Any, index: Int)
typealias MoveFetchedObjectAction = (object: Any, from: Int, to: Int)

class FetchedModelAdapterDelegateProxy: DelegateProxy<FetchedModelAdapter, FetchedModelAdapterDelegate>, DelegateProxyType, FetchedModelAdapterDelegate {
    
    init(parentObject: FetchedModelAdapter) {
        super.init(parentObject: parentObject, delegateProxy: FetchedModelAdapterDelegateProxy.self)
    }
    
    class func registerKnownImplementations() {
        self.register { FetchedModelAdapterDelegateProxy(parentObject: $0) }
    }
    
    class func currentDelegate(for object: FetchedModelAdapter) -> FetchedModelAdapterDelegate? {
        return object.delegate
    }
    
    class func setCurrentDelegate(_ delegate: FetchedModelAdapterDelegate?, to object: FetchedModelAdapter) {
        object.delegate = delegate
    }
}

extension Reactive where Base : FetchedModelAdapter {
    
    public var delegate: DelegateProxy<FetchedModelAdapter, FetchedModelAdapterDelegate> {
        return FetchedModelAdapterDelegateProxy.proxy(for: base)
    }
    
    var willChangeContent: Observable<Void> {
        return delegate
            .methodInvoked(#selector(FetchedModelAdapterDelegate.willChangeContent))
            .asVoid()
            .asObservable()
    }
    
    var didSetModels: Observable<[Any]> {
        return delegate
            .methodInvoked(#selector(FetchedModelAdapterDelegate.didSetModels(_:)))
            .map ({ a -> [Any] in
                return a[0] as! [Any]
            }).asObservable()
    }
    
    var didChangeContent: Observable<Void> {
         return delegate
            .methodInvoked(#selector(FetchedModelAdapterDelegate.didChangeContent))
            .asVoid()
            .asObservable()
    }
    
    var didInsert: Observable<FetchedObjectAction> {
        return delegate
            .methodInvoked(#selector(FetchedModelAdapterDelegate.didInsert(_:at:)))
            .map({ a -> FetchedObjectAction in
                return (object: a[0], index: Int(a[1] as! UInt))
            }).asObservable()
    }
    
    var didDelete: Observable<FetchedObjectAction> {
        return delegate
            .methodInvoked(#selector(FetchedModelAdapterDelegate.didDelete(_:at:)))
            .map({ a -> FetchedObjectAction in
                return (object: a[0], index: Int(a[1] as! UInt))
            }).asObservable()
    }
    
    var didUpdate: Observable<FetchedObjectAction> {
        return delegate
            .methodInvoked(#selector(FetchedModelAdapterDelegate.didUpdate(_:at:)))
            .map({ a -> FetchedObjectAction in
                return (object: a[0], index: Int(a[1] as! UInt))
            }).asObservable()
    }
    
    var didMove: Observable<MoveFetchedObjectAction> {
        return delegate
            .methodInvoked(#selector(FetchedModelAdapterDelegate.didMove(_:from:to:)))
            .map({ a -> MoveFetchedObjectAction in
                return (object: a[0], from: Int(a[1] as! UInt), to: Int(a[2] as! UInt))
            }).asObservable()
    }
    
    var reloadData: Observable<Void> {
        return delegate
            .methodInvoked(#selector(FetchedModelAdapterDelegate.reloadData))
            .asVoid()
            .asObservable()
    }
}
