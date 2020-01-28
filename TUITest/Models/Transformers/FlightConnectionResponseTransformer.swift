//
//  FlightConnectionResponseTransformer.swift
//  TUITest
//
//  Created by dushantsw on 2020-01-28.
//  Copyright © 2020 Spacetabs Ltd. All rights reserved.
//

import Foundation

class FlightConnectionResponseTransformer {
    static func transform(_ response: FlightConnectionsResponse) -> [FlightConnection] {
        return response.connections.compactMap({ connectionResponse in
            let from = Location(
                name: connectionResponse.from,
                latitude: connectionResponse.coordinates.from.lat,
                longitude: connectionResponse.coordinates.from.long)
            let to = Location(
                name: connectionResponse.to,
                latitude: connectionResponse.coordinates.to.lat,
                longitude: connectionResponse.coordinates.to.long)
            return FlightConnection(from: from, to: to, price: connectionResponse.price)
        })
    }
}
