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

struct FlightSearchViewModel {
    private var searchGraph = FlightSearchGraph()
    private var service: FlightDataService

    /// Delegate to model callbacks
    var delegate: FlightSearchDelegate?

    init(withService service: FlightDataService = .shared) {
        self.service = service
    }

    public func loadFlightConnections() {
        service.fetchFlights { response, error in
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
