//
//  FlightSearchGraphTests.swift
//  TUITestTests
//
//  Created by dushantsw on 2020-01-28.
//  Copyright © 2020 Spacetabs Ltd. All rights reserved.
//

import XCTest
import Nimble
@testable import TUITest

class FlightSearchGraphTests: XCTestCase {
    var flightConnections: [FlightConnection] = []
    let graph = FlightSearchGraph()

    var londonLocation = Location(name: "London", latitude: 51.5285582, longitude: -0.241681)
    var tokoyoLocation = Location(name: "Tokoyo", latitude: 35.652832, longitude: 139.839478)
    var newYorkLocation = Location(name: "New York", latitude: 40.73061, longitude: -73.935242)
    var portoLocation = Location(name: "Porto", latitude: 41.14961, longitude: -8.61099)
    var sydneyLocation = Location(name: "Sydney", latitude: -33.865143, longitude: 151.2099)
    var capeTownLocation = Location(name: "Cape Town", latitude: -33.918861, longitude: 18.4233)
    var losAngelesLocation = Location(name: "Los Angeles", latitude: 34.052235, longitude: -118.243683)

    override func setUp() {
        super.setUp()
        flightConnections.append(FlightConnection(from: londonLocation, to: tokoyoLocation, price: 220))
        flightConnections.append(FlightConnection(from: tokoyoLocation, to: londonLocation, price: 200))
        flightConnections.append(FlightConnection(from: londonLocation, to: portoLocation, price: 50))
        flightConnections.append(FlightConnection(from: londonLocation, to: newYorkLocation, price: 400))
        flightConnections.append(FlightConnection(from: tokoyoLocation, to: sydneyLocation, price: 100))
        flightConnections.append(FlightConnection(from: sydneyLocation, to: capeTownLocation, price: 200))
        flightConnections.append(FlightConnection(from: capeTownLocation, to: londonLocation, price: 800))
        flightConnections.append(FlightConnection(from: londonLocation, to: newYorkLocation, price: 400))
        flightConnections.append(FlightConnection(from: newYorkLocation, to: losAngelesLocation, price: 120))
        flightConnections.append(FlightConnection(from: losAngelesLocation, to: tokoyoLocation, price: 800))
        graph.createGraph(withFlightConnections: flightConnections)
    }

    func testThatDirectFromNewYorkToLosAngelesReturnsCorrectPrice() {
        // WHEN
        let result = graph.searchCheapestRoute(from: newYorkLocation, to: losAngelesLocation)

        // THEN
        expect{ try result.get() }.toNot(beNil())
        expect{ try result.get().via }.to(beNil())
        expect{ try result.get().totalCost }.to(equal(120))
    }

    func testThatTokoyoToPortoReturnsCorrectPrice() {
        // WHEN
        let result = graph.searchCheapestRoute(from: tokoyoLocation, to: portoLocation)

        // THEN
        expect{ try result.get() }.toNot(beNil())
        expect{ try result.get().via }.to(equal(londonLocation))
        expect{ try result.get().totalCost }.to(equal(250))
    }

    func testThatNonExistingFlightReturnsFailure() {
        // WHEN
        let result = graph.searchCheapestRoute(from: londonLocation, to: capeTownLocation)

        // THEN
        expect { try result.get() }.to(throwError(FlightSearchGraphError.noRouteFound))
    }
}
