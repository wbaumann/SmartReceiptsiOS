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

class FetchedModelAdapterDelegateProxy: DelegateProxy, DelegateProxyType, FetchedModelAdapterDelegate {
    class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let fetchedModelAdapter: FetchedModelAdapter = (object as? FetchedModelAdapter)!
        return fetchedModelAdapter.delegate
    }
    
    class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let fetchedModelAdapter = object as! FetchedModelAdapter
        fetchedModelAdapter.delegate = delegate as? FetchedModelAdapterDelegate
    }
}

extension Reactive where Base : FetchedModelAdapter {
    
    public var delegate: DelegateProxy {
        return FetchedModelAdapterDelegateProxy.proxyForObject(base)
    }
    
    var willChangeContent: Observable<Void> {
        return delegate
            .methodInvoked(#selector(FetchedModelAdapterDelegate.willChangeContent))
            .map { _ -> Void in }
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
            .map { _ -> Void in }
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
            .map { _ -> Void in }
            .asObservable()
    }
}
