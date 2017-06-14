//
//  EditTripView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift
import RxCocoa

//MARK: - Public Interface Protocol
protocol EditTripViewInterface {
    func setup(trip: WBTrip)
}

//MARK: EditTripView Class
final class EditTripView: UserInterface {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!

    private var formView: EditTripFormView!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formView = EditTripFormView(trip: displayData.trip)
        addChildViewController(formView)
        view.addSubview(formView.view)
        setupInitialState()
        configureUIActions()
        configureSubscribes()
    }
    
    private func setupInitialState() {
        navigationItem.title = self.displayData.trip == nil ?
            LocalizedString("edit.trip.controller.add.title") :
            LocalizedString("edit.trip.controller.edit.title")
    }
    
    private func configureUIActions() {
        cancelButton.rx.tap.subscribe(onNext: {
            self.presenter.close()
        }).disposed(by: disposeBag)
        
        doneButton.rx.tap.subscribe(onNext: {
            self.formView.done()
        }).disposed(by: disposeBag)
    }
    
    private func configureSubscribes() {
        formView.errorSubject.subscribe(onNext: { errorDescripton in
            self.presenter.presentAlert(title: nil, message: errorDescripton)
        }).addDisposableTo(disposeBag)
        
        formView.tripSubject.subscribe(onNext: { trip in
            self.displayData.trip == nil ?
                self.presenter.addTripSubject.onNext(trip) :
                self.presenter.updateTripSubject.onNext(trip)
        }).disposed(by: disposeBag)
    }
}

//MARK: - Public interface
extension EditTripView: EditTripViewInterface {
    func setup(trip: WBTrip) {
        displayData.trip = trip
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditTripView {
    var presenter: EditTripPresenter {
        return _presenter as! EditTripPresenter
    }
    var displayData: EditTripDisplayData {
        return _displayData as! EditTripDisplayData
    }
}
