//
//  FlightDataServiceTests.swift
//  TUITestTests
//
//  Created by dushantsw on 2020-01-28.
//  Copyright © 2020 Spacetabs Ltd. All rights reserved.
//

import XCTest
import Nimble
@testable import TUITest

enum FlightDataServiceTestsError: Error {
    case mockSessionError
}

class FlightDataServiceTests: XCTestCase {
    private let json = """
    {"connections":[{"from":"London","to":"Tokyo","coordinates":{"from":{"lat":51.5285582,"long":-0.241681},"to":{"lat":35.652832,"long":139.839478}},"price":220}]}
    """

    func testThatServerErrorReturnsError() {
        // GIVEN
        let mockSession = URLSessionMock()
        mockSession.error = FlightDataServiceTestsError.mockSessionError
        FlightDataService.shared.sharedSession = mockSession

        // WHEN
        var error: Error?
        FlightDataService.shared.fetchFlights { _, serviceError in error = serviceError }

        // THEN
        expect(error).toNotEventually(beNil())
        expect(error).toEventually(matchError(FlightDataServiceTestsError.mockSessionError))
    }

    func testThatServerEmptyResponseReturnsError() {
        // GIVEN
        let mockSession = URLSessionMock()
        FlightDataService.shared.sharedSession = mockSession

        // WHEN
        var error: Error?
        FlightDataService.shared.fetchFlights { _, serviceError in error = serviceError }

        // THEN
        expect(error).toNotEventually(beNil())
        expect(error).toEventually(matchError(FlightDataServiceError.invalidResponse))
    }

    func testThatServer200ReturnsCorrectObject() {
        // GIVEN
        let mockSession = URLSessionMock()
        mockSession.data = json.data(using: .utf8) ?? Data()
        FlightDataService.shared.sharedSession = mockSession

        // WHEN
        var response: FlightConnectionsResponse?
        FlightDataService.shared.fetchFlights { connectionsResponse, _ in response = connectionsResponse }

        // THEN
        expect(response).toEventuallyNot(beNil())
        expect(response?.connections).toEventuallyNot(beEmpty())
    }
}
