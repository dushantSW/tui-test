//
//  FlightConnectionResponse.swift
//  TUITest
//
//  Created by dushantsw on 2020-01-28.
//  Copyright © 2020 Spacetabs Ltd. All rights reserved.
//

import Foundation

struct FlightConnectionResponseGeoCoordinates: Codable {
    let lat: Double
    let long: Double
}

struct FlightConnectionResponseCoordinates: Codable {
    let from: FlightConnectionResponseGeoCoordinates
    let to: FlightConnectionResponseGeoCoordinates
}

struct FlightResponse: Codable {
    let from: String
    let to: String
    let price: Double
    let coordinates: FlightConnectionResponseCoordinates
}

struct FlightConnectionsResponse: Codable {
    let connections: [FlightResponse]
}
