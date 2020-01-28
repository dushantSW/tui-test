//
//  FlightSearchGraphError.swift
//  TUITest
//
//  Created by dushantsw on 2020-01-28.
//  Copyright © 2020 Spacetabs Ltd. All rights reserved.
//

import Foundation

enum FlightSearchGraphError: Error {
    case noRouteFound, departureNodeNotFound, arrivalNodeNotFound
}
