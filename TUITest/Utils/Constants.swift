//
//  Utils.swift
//  TUITest
//
//  Created by dushantsw on 2020-01-29.
//  Copyright © 2020 Spacetabs Ltd. All rights reserved.
//

import Foundation

enum GeneralError: LocalizedError {
    case unexpectedError

    var errorDescription: String? {
        switch self {
        default: return "An unexpected occur occured. Please try again!"
        }
    }
}

class Constants {
    /// Standard currency formatter for RP
    static var currencyFormatter: Formatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_GB")
        return formatter
    }()
}
