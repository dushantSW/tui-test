//
//  FlightSuggestionDisplayController.swift
//  TUITest
//
//  Created by dushantsw on 2020-01-28.
//  Copyright © 2020 Spacetabs Ltd. All rights reserved.
//

import Foundation
import UIKit

/// Defines the delegate for user events
protocol LocationSuggestionDisplayDelegate: class {

    /// Called when the user has selected one of the suggestions
    /// - Parameters:
    ///   - controller: Model calling this.
    ///   - didSelectLocation: Location that has been selected
    func locationSuggestionDisplayerController(_ controller: LocationSuggestionDisplayController, didSelectLocation: Location)
}

class LocationSuggestionDisplayController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Public properties
    var viewModel: LocationSuggestionDisplayViewModel!
    weak var delegate: LocationSuggestionDisplayDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    // MARK: - Search
    public func search(withTerm term: String) {
        viewModel.startSearching(forSearchTerm: term)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension LocationSuggestionDisplayController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let location = viewModel?.searchLocation(for: indexPath.row) else {
            return displayAlert(title: "Error", message: GeneralError.unexpectedError.errorDescription ?? "")
        }
        delegate?.locationSuggestionDisplayerController(self, didSelectLocation: location)
    }
}

// MARK: - UITableViewDataSource
extension LocationSuggestionDisplayController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tryingMakingCell: () -> UITableViewCell? = {
            guard let location = self.viewModel.searchLocation(for: indexPath.row) else { return nil }
            var cell = tableView.dequeueReusableCell(withIdentifier: self.viewModel.defaultCellIdentifier)
            if cell == nil { cell = UITableViewCell(style: .default, reuseIdentifier: self.viewModel.defaultCellIdentifier) }
            cell?.textLabel?.text = location.name.capitalized
            return cell
        }
        return tryingMakingCell() ?? UITableViewCell()
    }
}
