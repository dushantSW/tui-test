//
//  LocationSuggestionDisplayViewModel.swift
//  TUITest
//
//  Created by dushantsw on 2020-01-28.
//  Copyright © 2020 Spacetabs Ltd. All rights reserved.
//

import Foundation

struct LocationSuggestionDisplayViewModel {
    private(set) var searchFoundLocations: [Location]?
    private let availableLocations: [Location]

    /// Returns default cell identifier
    let defaultCellIdentifier = "LocationSuggestionDisplayTableViewCell"

    /// Returns number of the rows that the table should display
    var numberOfRows: Int {
        return searchFoundLocations?.count ?? 0
    }

    init(locations: [Location]) {
        self.availableLocations = locations
    }

    /// Returns the searched location from the array if available
    /// - Parameter index: position of the location
    public func searchLocation(for index: Int) -> Location? {
        return searchFoundLocations?[safe: index]
    }

    /// Starts the searching for the location with the given name and
    /// stores it in this model under an array.
    ///
    /// Any found locations are available under searchLocation(for index:)
    /// - Parameter term: Term that we are searching for.
    public mutating func startSearching(forSearchTerm term: String) {
        self.searchFoundLocations = availableLocations.filter({ $0.name.localizedCaseInsensitiveContains(term) })
    }
}
