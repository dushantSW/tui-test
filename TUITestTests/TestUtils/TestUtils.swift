//
//  TestUtils.swift
//  TUITestTests
//
//  Created by dushantsw on 2020-01-28.
//  Copyright © 2020 Spacetabs Ltd. All rights reserved.
//

import Foundation
import Fakery
@testable import TUITest

class TestUtils {
    private static let locationNames = ["London", "Tokyo", "New York", "Paris"]

    static func generateLocations() -> [TUITest.Location] {
        var locations: [TUITest.Location] = []
        for index in 0...(locationNames.count - 1) {
            let faker = Faker(locale: "en-GB")
            let location = TUITest.Location(
                name: locationNames[index],
                latitude: faker.address.latitude(),
                longitude: faker.address.longitude())
            locations.append(location)
        }
        return locations
    }
}
