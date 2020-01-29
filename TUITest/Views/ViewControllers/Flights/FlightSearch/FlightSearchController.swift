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

    @IBOutlet private weak var costTitleLabel: UILabel!
    @IBOutlet private weak var costLabel: UILabel!

    private var suggestionController: LocationSuggestionDisplayController?
    private var indicator: UIActivityIndicatorView?

    var viewModel = FlightSearchViewModel()

    // MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setCost(0.0)
        viewModel.delegate = self
        createIndicator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        indicator?.startAnimating()
        viewModel.loadFlightConnections()
    }

    // MARK: - Suggestions controller
    private func createSuggestionsController() {
        let storyboard = UIStoryboard(name: "FlightSearch", bundle: .main)
        let identifier = "LocationSuggestionDisplayController"
        guard let controller = storyboard.instantiateViewController(withIdentifier: identifier) as? LocationSuggestionDisplayController else { return }
        controller.viewModel = LocationSuggestionDisplayViewModel(locations: viewModel.availableLocations ?? [])
        controller.delegate = self
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: view.frame.width / 2, height: view.frame.height / 2)
        self.suggestionController = controller
    }

    private func showSuggestionController(forTextField textField: UITextField) {
        guard let controller = suggestionController else { return }
        let presentationController = controller.popoverPresentationController
        presentationController?.sourceView = textField
        presentationController?.sourceRect = textField.bounds
        presentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        presentationController?.delegate = self
        present(controller, animated: true, completion: nil)
    }

    private func hideSuggestionController() {
        suggestionController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - Search
    private func startSearchIfNeeded() {
        guard let departure = departureTextField.text?.trimmingCharacters(in: .whitespaces), !departure.isEmpty else { return }
        guard let arrival = arrivalTextField.text?.trimmingCharacters(in: .whitespaces), !arrival.isEmpty else { return }
        guard departure != arrival else { return }
        do {
            let route = try viewModel.search(from: departure, to: arrival)
            self.setCost(route.totalCost)
        } catch (let error) {
            if error is FlightSearchViewModelError {
                displayAlert(title: "Error", message: (error as? LocalizedError)?.errorDescription ?? "")
            } else {
                displayAlert(title: "Error", message: "No route was found between \(departure) -> \(arrival)")
            }
            self.setCost(0.0)
        }
    }

    // MARK: - Cost setting
    private func setCost(_ cost: Double) {
        costTitleLabel.isHidden = cost == 0.0
        costLabel.isHidden = cost == 0.0
        costLabel.text = Constants.currencyFormatter.string(for: cost)
    }

    // MARK: - Indicator
    private func createIndicator() {
        self.indicator = UIActivityIndicatorView(style: .medium)
        indicator?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator?.center = view.center
        self.view.addSubview(indicator!)
        self.view.bringSubviewToFront(indicator!)
    }
}

extension FlightSearchController: FlightSearchDelegate {
    func flightSearchModel(_ model: FlightSearchViewModel, fetchDidReturnError error: Error) {
        indicator?.stopAnimating()
        displayAlert(title: "Error", message: error.localizedDescription)
    }

    func fetchDidReturnWithNoData(_ model: FlightSearchViewModel) {
        indicator?.stopAnimating()
        displayAlert(title: "Error", message: GeneralError.unexpectedError.errorDescription ?? "")
    }

    func fetchDidRetrieveConnections(_ model: FlightSearchViewModel) {
        indicator?.stopAnimating()
        createSuggestionsController()
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
        hideSuggestionController()
        startSearchIfNeeded()
    }
}

extension FlightSearchController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        suggestionController?.search(withTerm: textField.text ?? "")
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == departureTextField {
            departureTextField.resignFirstResponder()
            arrivalTextField.becomeFirstResponder()
        } else if textField == arrivalTextField {
            arrivalTextField.resignFirstResponder()
        }
        startSearchIfNeeded()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideSuggestionController()
        showSuggestionController(forTextField: textField)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        startSearchIfNeeded()
    }
}

extension FlightSearchController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
