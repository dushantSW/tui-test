//
//  FlightDataService.swift
//  TUITest
//
//  Created by dushantsw on 2020-01-28.
//  Copyright © 2020 Spacetabs Ltd. All rights reserved.
//

import Foundation

enum FlightDataServiceError: Error {
    case invalidEndpoint, invalidResponse
}

/// Service class for communication between the client
/// and the backend for fetching flights.
class FlightDataService {
    private let urlConnections = "https://raw.githubusercontent.com/TuiMobilityHub/ios-code-challenge/master/connections.json"

    /// Shared instance of this.
    static let shared = FlightDataService()

    /// Keeping this property open for testing
    var sharedSession = URLSession.shared

    /// Fetches the flights from the service.
    ///
    /// - Parameter completion: block called when the either response or error is to be returned.
    public func fetchFlights(completion: @escaping  (_ object: FlightConnectionsResponse?, _ error: Error?) -> Void) {
        guard let url = URL(string: urlConnections) else { return completion(nil, FlightDataServiceError.invalidEndpoint) }
        sharedSession.dataTask(with: url) { data, _, error in
            if let error = error { return completion(nil, error) }
            guard let data = data else { return completion(nil, FlightDataServiceError.invalidResponse) }
            // Decode and return response
            let decoder = JSONDecoder()
            let connectionsResponse = try? decoder.decode(FlightConnectionsResponse.self, from: data)
            completion(connectionsResponse, nil)
        }.resume()
    }
}
