//
//  EditDistanceView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift
import RxCocoa

//MARK: - Public Interface Protocol
protocol EditDistanceViewInterface {
    func setup(trip: WBTrip, distance: Distance?)
}

//MARK: EditDistance View
final class EditDistanceView: UserInterface {
    
    private var formView: EditDistanceFormView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formView = EditDistanceFormView(trip: displayData.trip!, distance: displayData.distance)
        
        addChildViewController(formView)
        formView.view.frame = view.bounds
        view.addSubview(formView.view)
        setupInitialState()
    }
    
    private func setupInitialState() {
        let isEdit = displayData.distance != nil
        
        navigationItem.title = isEdit ?
            LocalizedString("edit.distance.controller.edit.title") :
            LocalizedString("edit.distance.controller.add.title")
    }
    
    //MARK: Actions
    @IBAction private func onSaveTap() {
        let errorsDescription = formView.validate()
        if errorsDescription.isEmpty {
            let distance = formView!.changedDistance!
            presenter.save(distance: distance, asNewDistance: displayData.distance == nil)
        } else {
            let alert = UIAlertView(title: LocalizedString("edit.distance.controller.validation.error.title"),
              message: errorsDescription, delegate: nil, cancelButtonTitle: LocalizedString("generic.button.title.ok"))
            alert.show()
        }
    }
}

//MARK: - Public interface
extension EditDistanceView: EditDistanceViewInterface {
    func setup(trip: WBTrip, distance: Distance?) {
        displayData.trip = trip
        displayData.distance = distance
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditDistanceView {
    var presenter: EditDistancePresenter {
        return _presenter as! EditDistancePresenter
    }
    var displayData: EditDistanceDisplayData {
        return _displayData as! EditDistanceDisplayData
    }
}
