//
//  TooltipPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 30/08/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift

class TooltipPresenter {
    private let bag = DisposeBag()
    private weak var view: UIView!
    private let trip: WBTrip
    
    private var reportTooltip: TooltipView?
    private var syncErrorTooltip: TooltipView?
    
    private let errorTapSubject = PublishSubject<SyncError>()
    private let generateTapSubject = PublishSubject<Void>()
    private let updateInsetsSubject = PublishSubject<UIEdgeInsets>()
    
    var errorTap: Observable<SyncError> { return errorTapSubject.asObservable() }
    var generateTap: Observable<Void> { return generateTapSubject.asObservable() }
    var updateInsets: Observable<UIEdgeInsets> { return updateInsetsSubject.asObservable() }
    
    init(view: UIView, trip: WBTrip) {
        self.trip = trip
        self.view = view
        
        BackupProvidersManager.shared.getCriticalSyncErrorStream()
            .subscribe(onNext: { [unowned self] syncError in
                self.presentSyncError(syncError)
            }).disposed(by: bag)
        
    }
    
    func presentSyncError(_ syncError: SyncError) {
        syncErrorTooltip?.removeFromSuperview()
        syncErrorTooltip = nil
        
        updateInsetsSubject.onNext(TOOLTIP_INSETS)
        
        let offset = CGPoint(x: 0, y: TooltipView.HEIGHT)
        let text = syncError.localizedDescription
        var screenWidth = false
        executeFor(iPhone: { screenWidth = true }, iPad: { screenWidth = false })
        
        syncErrorTooltip = TooltipView.showErrorOn(view: view, text: text, offset: offset, screenWidth: screenWidth)
        
        syncErrorTooltip?.rx.tap.subscribe(onNext: { [unowned self] in
            self.updateInsetsSubject.onNext(.zero)
            self.syncErrorTooltip = nil
            self.errorTapSubject.onNext(syncError)
        }).disposed(by: bag)
        
        syncErrorTooltip?.rx.close.subscribe(onNext: { [unowned self] in
            self.updateInsetsSubject.onNext(.zero)
            self.syncErrorTooltip = nil
        }).disposed(by: bag)
    }
    
    func presentGenerateIfNeeded() {
        if !TooltipService.shared.moveToGenerateTrigger(for: trip) || syncErrorTooltip != nil {
            return
        }
        
        if let text = TooltipService.shared.generateTooltip(for: trip), reportTooltip == nil {
            updateInsetsSubject.onNext(TOOLTIP_INSETS)
            let offset = CGPoint(x: 0, y: TooltipView.HEIGHT)
            
            var screenWidth = false
            executeFor(iPhone: { screenWidth = true }, iPad: { screenWidth = false })
            reportTooltip = TooltipView.showOn(view: view, text: text, offset: offset, screenWidth: screenWidth)
            
            reportTooltip?.rx.tap.subscribe(onNext: { [unowned self] in
                TooltipService.shared.markMoveToGenerateDismiss()
                self.updateInsetsSubject.onNext(.zero)
                self.generateTapSubject.onNext()
                self.reportTooltip = nil
            }).disposed(by: bag)
            
            reportTooltip?.rx.close.subscribe(onNext: { [unowned self] in
                TooltipService.shared.markMoveToGenerateDismiss()
                self.updateInsetsSubject.onNext(.zero)
                self.reportTooltip = nil
            }).disposed(by: bag)
        }
    }
}
