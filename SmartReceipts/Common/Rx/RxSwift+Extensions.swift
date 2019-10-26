//
//  RxSwift+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift
import RxCocoa

let BackgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .default)

extension AnyObserver {
    init(onNext: ((E) -> Swift.Void)? = nil, onError: ((Error) -> Swift.Void)? = nil, onCompleted: (() -> Swift.Void)? = nil) {
        self.init { event in
            switch event {
            case .next(let element):
                onNext?(element)
            case .error(let error):
                onError?(error)
            case .completed:
                onCompleted?()
            }
        }
    }
}

extension Observable {
    func skipFirst() -> Observable<Element> {
        return skip(1)
    }
    
    func asVoid() -> Observable<Void> {
        return map({ _ -> Void in })
    }
    
    func delayEach(seconds: RxTimeInterval, scheduler: SchedulerType) -> Observable<Element> {
        return RxSwift.Observable.zip(self, Observable<Int>.interval(seconds, scheduler: scheduler)).map({ $0.0 })
    }
}

extension Completable {
    func asSingle() -> Single<Void> {
        return Single<Void>.create(subscribe: { single -> Disposable in
            let subscribe = self.subscribe(onCompleted: {
                single(.success(()))
            }, onError: {
                single(.error($0))
            })
            return Disposables.create([subscribe])
        })
    }
}

extension Array {
    func asObservable() -> Observable<Element> {
        return .create({ observer -> Disposable in
            for element in self {
                observer.onNext(element)
            }
            observer.onCompleted()
            return Disposables.create()
        })
    }
}

extension Observable where Element == Void {
    static var just: Observable<Element> {
        return .just(())
    }
}

extension ObserverType where E == Void {
    func onNext() {
        on(.next(()))
    }
}

extension ObservableType where E: Equatable {
    func filterCases(cases: E...) -> Observable<E> {
        return filter { cases.contains($0) }
    }
}
