//
//  LocationSuggestionViewModelTests.swift
//  TUITestTests
//
//  Created by dushantsw on 2020-01-28.
//  Copyright © 2020 Spacetabs Ltd. All rights reserved.
//

import XCTest
import Nimble
@testable import TUITest

class LocationSuggestionViewModelTests: XCTestCase {
    func testThatExistingLocationMiddleSearchReturnsValues() {
        // GIVEN
        let middleSearchTerm = "nd"
        var viewModel = LocationSuggestionDisplayViewModel(locations: TestUtils.generateLocations())

        // WHEN
        viewModel.startSearching(forSearchTerm: middleSearchTerm)

        // THEN
        expect(viewModel.searchFoundLocations).toNot(beNil())
        expect(viewModel.searchFoundLocations).toNot(beEmpty())
        expect(viewModel.searchFoundLocations?.filter({ $0.name == "London" })).toNot(beNil())
    }

    func testThatExistingLocationStartSearchReturnsValues() {
        // GIVEN
        let startSearchTerm = "Lo"
        var viewModel = LocationSuggestionDisplayViewModel(locations: TestUtils.generateLocations())

        // WHEN
        viewModel.startSearching(forSearchTerm: startSearchTerm)

        // THEN
        expect(viewModel.searchFoundLocations).toNot(beNil())
        expect(viewModel.searchFoundLocations).toNot(beEmpty())
        expect(viewModel.searchFoundLocations?.filter({ $0.name == "London" })).toNot(beNil())
    }

    func testThatExistingLocationEndSearchReturnsValues() {
        // GIVEN
        let endSearchTerm = "on"
        var viewModel = LocationSuggestionDisplayViewModel(locations: TestUtils.generateLocations())

        // WHEN
        viewModel.startSearching(forSearchTerm: endSearchTerm)

        // THEN
        expect(viewModel.searchFoundLocations).toNot(beNil())
        expect(viewModel.searchFoundLocations).toNot(beEmpty())
        expect(viewModel.searchFoundLocations?.filter({ $0.name == "London" })).toNot(beNil())
    }

    func testThatExistingLocationCaseInsenstiveSearchReturnsValues() {
        // GIVEN
        let caseInsensitiveTerm = "lo"
        var viewModel = LocationSuggestionDisplayViewModel(locations: TestUtils.generateLocations())

        // WHEN
        viewModel.startSearching(forSearchTerm: caseInsensitiveTerm)

        // THEN
        expect(viewModel.searchFoundLocations).toNot(beNil())
        expect(viewModel.searchFoundLocations).toNot(beEmpty())
        expect(viewModel.searchFoundLocations?.filter({ $0.name == "London" })).toNot(beNil())
    }

    func testThatNotExistingLocationDoesNOTReturnValues() {
        // GIVEN
        let term = "roman"
        var viewModel = LocationSuggestionDisplayViewModel(locations: [])

        // WHEN
        viewModel.startSearching(forSearchTerm: term)

        // THEN
        expect(viewModel.searchFoundLocations).toNot(beNil())
        expect(viewModel.searchFoundLocations).to(beEmpty())
    }
}
