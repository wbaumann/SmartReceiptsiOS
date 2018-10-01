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
    private var reminderTooltip: TooltipView?
    
    private let errorTapSubject = PublishSubject<SyncError>()
    private let generateTapSubject = PublishSubject<Void>()
    private let updateInsetsSubject = PublishSubject<UIEdgeInsets>()
    private let reminderTapSubject = PublishSubject<Void>()
    
    var updateInsets: Observable<UIEdgeInsets> { return updateInsetsSubject.asObservable() }
    var errorTap: Observable<SyncError> { return errorTapSubject.asObservable() }
    var generateTap: Observable<Void> { return generateTapSubject.asObservable() }
    var reminderTap: Observable<Void> { return reminderTapSubject.asObservable() }
    
    init(view: UIView, trip: WBTrip) {
        self.trip = trip
        self.view = view
        
        BackupProvidersManager.shared.getCriticalSyncErrorStream()
            .filter({ $0 != .unknownError })
            .delay(0.1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] syncError in
                self.presentSyncError(syncError)
            }).disposed(by: bag)
        
        AppNotificationCenter.didSyncBackup
            .subscribe(onNext: { [unowned self] in
                self.presentBackupReminderIfNeeded()
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
            self.syncErrorTooltip = nil
            self.errorTapSubject.onNext(syncError)
            self.updateViewInsets()
        }).disposed(by: bag)
        
        syncErrorTooltip?.rx.close.subscribe(onNext: { [unowned self] in
            self.syncErrorTooltip = nil
            self.updateViewInsets()
        }).disposed(by: bag)
    }
    
    func presentBackupReminderIfNeeded() {
        reminderTooltip?.removeFromSuperview()
        reminderTooltip = nil
        
        if let text = TooltipService.shared.tooltipBackupReminder(), reportTooltip == nil {
            updateInsetsSubject.onNext(TOOLTIP_INSETS)
            let offset = CGPoint(x: 0, y: TooltipView.HEIGHT)
            
            var screenWidth = false
            executeFor(iPhone: { screenWidth = true }, iPad: { screenWidth = false })
            reminderTooltip = TooltipView.showOn(view: view, text: text, image: #imageLiteral(resourceName: "info"), offset: offset, screenWidth: screenWidth)
            
            reminderTooltip?.rx.tap.subscribe(onNext: { [unowned self] in
                TooltipService.shared.markBackupReminderDismissed()
                self.reminderTapSubject.onNext(())
                self.reminderTooltip = nil
                self.updateViewInsets()
            }).disposed(by: bag)
            
            reminderTooltip?.rx.close.subscribe(onNext: { [unowned self] in
                TooltipService.shared.markBackupReminderDismissed()
                self.reminderTooltip = nil
                self.updateViewInsets()
            }).disposed(by: bag)
        }
    }
    
    func presentGenerateIfNeeded() {
        if !TooltipService.shared.moveToGenerateTrigger(for: trip) || syncErrorTooltip != nil || reminderTooltip != nil {
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
                self.generateTapSubject.onNext(())
                self.reportTooltip = nil
                self.updateViewInsets()
            }).disposed(by: bag)
            
            reportTooltip?.rx.close.subscribe(onNext: { [unowned self] in
                TooltipService.shared.markMoveToGenerateDismiss()
                self.reportTooltip = nil
                self.updateViewInsets()
            }).disposed(by: bag)
        }
    }
    
    private func updateViewInsets() {
        let insets: UIEdgeInsets = reportTooltip == nil && reminderTooltip == nil && syncErrorTooltip == nil ? .zero : TOOLTIP_INSETS
        self.updateInsetsSubject.onNext(insets)
    }
}
