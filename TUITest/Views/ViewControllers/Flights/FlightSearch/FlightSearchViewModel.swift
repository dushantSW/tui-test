//
//  FlightSearchViewModel.swift
//  TUITest
//
//  Created by dushantsw on 2020-01-28.
//  Copyright © 2020 Spacetabs Ltd. All rights reserved.
//

import Foundation

protocol FlightSearchDelegate {
    func flightSearchModel(_ model: FlightSearchViewModel, fetchDidReturnError error: Error)
    func fetchDidReturnWithNoData(_ model: FlightSearchViewModel)
    func fetchDidRetrieveConnections(_ model: FlightSearchViewModel)
}

enum FlightSearchViewModelError: LocalizedError {
    case locationNotfound(name: String)

    var errorDescription: String? {
        switch self {
        case .locationNotfound(let name): return "Location with name: \(name) was not found"
        }
    }
}

struct FlightSearchViewModel {
    private var searchGraph = FlightSearchGraph()
    private var service: FlightDataService

    /// Delegate to model callbacks
    var delegate: FlightSearchDelegate?

    /// Returns an array of the available locations
    var availableLocations: [Location]? {
        return Array(searchGraph.locations ?? Set())
    }

    init(withService service: FlightDataService = .shared) {
        self.service = service
    }

    public func search(from: String, to: String) throws -> Route {
        guard let depature = searchGraph.location(byName: from) else {
            throw FlightSearchViewModelError.locationNotfound(name: from)
        }
        guard let arrival = searchGraph.location(byName: to) else {
            throw FlightSearchViewModelError.locationNotfound(name: to)
        }
        return try searchGraph.searchCheapestRoute(from: depature, to: arrival).get()
    }

    public func loadFlightConnections() {
        service.fetchFlights { response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.delegate?.flightSearchModel(self, fetchDidReturnError: error)
                    return
                }
                guard let response = response else {
                    self.delegate?.fetchDidReturnWithNoData(self); return
                }
                let connections = FlightConnectionResponseTransformer.transform(response)
                self.searchGraph.createGraph(withFlightConnections: connections)
                self.delegate?.fetchDidRetrieveConnections(self)
            }
        }
    }
}
