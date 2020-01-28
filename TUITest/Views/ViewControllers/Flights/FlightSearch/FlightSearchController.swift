//
//  FlightSearchController.swift
//  TUITest
//
//  Created by dushantsw on 2020-01-28.
//  Copyright © 2020 Spacetabs Ltd. All rights reserved.
//

import Foundation
import UIKit

class FlightSearchController: UIViewController {
    @IBOutlet private weak var departureTextField: UITextField!
    @IBOutlet private weak var arrivalTextField: UITextField!

    var viewModel: FlightSearchViewModel?

    // MARK: - Search
    private func startSearchIfNeeded() {
        
    }
}

// MARK: - LocationSuggestionDisplayDelegate
extension FlightSearchController: LocationSuggestionDisplayDelegate {
    func locationSuggestionDisplayerController(_ controller: LocationSuggestionDisplayController, didSelectLocation: Location) {
        if departureTextField.isFirstResponder {
            departureTextField.text = didSelectLocation.name
            departureTextField.resignFirstResponder()
        } else if arrivalTextField.isFirstResponder {
            arrivalTextField.text = didSelectLocation.name
            arrivalTextField.resignFirstResponder()
        }
        startSearchIfNeeded()
    }
}
