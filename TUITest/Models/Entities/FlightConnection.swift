//
//  Flight.swift
//  TUITest
//
//  Created by dushantsw on 2020-01-28.
//  Copyright © 2020 Spacetabs Ltd. All rights reserved.
//

import Foundation

/// Describes a single location on the map by it's
/// name, lat and long coordinates.
struct Location: Equatable, Hashable {
    let name: String
    let latitude: Double
    let longitude: Double

    /// Returns the coordinates to south pole for invalid locations
    static func southPole() -> Location {
        return Location(name: "South pole", latitude: -90.0000, longitude: 0.0000)
    }
}

/// Describes a single flight connection from one given
/// location to another given location.
///
/// Can contain other properties like price etc.
struct FlightConnection {
    let from: Location
    let to: Location
    let price: Double
}
