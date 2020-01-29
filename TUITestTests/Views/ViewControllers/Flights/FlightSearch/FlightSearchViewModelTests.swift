//
//  FlightSearchViewModelTests.swift
//  TUITestTests
//
//  Created by dushantsw on 2020-01-28.
//  Copyright © 2020 Spacetabs Ltd. All rights reserved.
//

import XCTest
import Nimble
@testable import TUITest

class FlightDataServiceMock: FlightDataService {
    var response: FlightConnectionsResponse?
    var error: Error?

    override func fetchFlights(completion: @escaping (FlightConnectionsResponse?, Error?) -> Void) {
        completion(response, error)
    }
}

class FlightSearchViewModelDelegateMock: FlightSearchDelegate {
    var noDataCalled = false, connectionsRetrievedCalled = false, errorCalled = false

    func fetchDidReturnWithNoData(_ model: FlightSearchViewModel) {
        noDataCalled = true
    }

    func fetchDidRetrieveConnections(_ model: FlightSearchViewModel) {
        connectionsRetrievedCalled = true
    }

    func flightSearchModel(_ model: FlightSearchViewModel, fetchDidReturnError error: Error) {
        errorCalled = true
    }
}

class FlightSearchGraphMock: FlightSearchGraph {
    var location: Location?
    var searchingName: String?

    override func location(byName name: String) -> Location? {
        if let searchingName = searchingName, searchingName == name { return location }
        return nil
    }

    override func searchCheapestRoute(from: Location, to: Location) -> Result<Route, Error> {
        return .success(Route(from: from, to: to, legs: nil, totalCost: 20))
    }
}

class FlightSearchViewModelTests: XCTestCase {
    func testThatViewModelErrorCallsErrorDelegate() {
        // GIVEN
        let mockService = FlightDataServiceMock()
        mockService.error = FlightDataServiceTestsError.mockSessionError

        let delegate = FlightSearchViewModelDelegateMock()
        var viewModel = FlightSearchViewModel(withService: mockService)
        viewModel.delegate = delegate

        // WHEN
        viewModel.loadFlightConnections()

        // THEN
        expect(delegate.errorCalled).toEventually(beTrue())
    }

    func testThatViewModelEmptyDataCallsEmptyDelegate() {
        // GIVEN
        let mockService = FlightDataServiceMock()
        let delegate = FlightSearchViewModelDelegateMock()
        var viewModel = FlightSearchViewModel(withService: mockService)
        viewModel.delegate = delegate

        // WHEN
        viewModel.loadFlightConnections()

        // THEN
        expect(delegate.noDataCalled).toEventually(beTrue())
    }

    func testThatViewModelSuccessCallsSuccessDelegate() {
        // GIVEN
        let mockService = FlightDataServiceMock()
        mockService.response = FlightConnectionsResponse(connections: [])

        let delegate = FlightSearchViewModelDelegateMock()
        var viewModel = FlightSearchViewModel(withService: mockService)
        viewModel.delegate = delegate

        // WHEN
        viewModel.loadFlightConnections()

        // THEN
        expect(delegate.connectionsRetrievedCalled).toEventually(beTrue())
    }

    func testThatSearchInvalidDepartureReturnsError() {
        let viewModel = FlightSearchViewModel(searchGraph: FlightSearchGraphMock())

        expect { try viewModel.search(from: "London", to: "Parise") }
            .to(throwError(FlightSearchViewModelError.locationNotfound(name: "London")))
    }

    func testThatSearchInvalidArrivalReturnsError() {
        let graphMock = FlightSearchGraphMock()
        graphMock.searchingName = "Departure"
        graphMock.location = .southPole()

        let viewModel = FlightSearchViewModel(searchGraph: graphMock)

        expect { try viewModel.search(from: "Departure", to: "Arrival") }
            .to(throwError(FlightSearchViewModelError.locationNotfound(name: "Arrival")))
    }

    func testThatSearchValidLocationsReturnRoute() {
        let graphMock = FlightSearchGraphMock()
        graphMock.searchingName = "Destination"
        graphMock.location = .southPole()

        let viewModel = FlightSearchViewModel(searchGraph: graphMock)

        let result = try? viewModel.search(from: "Destination", to: "Destination")
        expect(result).toNot(beNil())
        expect(result?.totalCost).to(equal(20))
    }
}
