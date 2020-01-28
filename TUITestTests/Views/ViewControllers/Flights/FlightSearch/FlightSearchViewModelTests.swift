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
}
