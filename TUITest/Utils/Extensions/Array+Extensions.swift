//
//  Array+Extensions.swift
//  TUITest
//
//  Created by dushantsw on 2020-01-28.
//  Copyright © 2020 Spacetabs Ltd. All rights reserved.
//

extension Collection {
    /// Returns the element for the given index safely,
    /// if the index is not found then nil.
    ///
    /// - Parameter index: Index
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


extension Array {
    /// Returns the element for the given index safely,
    /// if the index is not found then nil.
    ///
    /// - Parameter index: Index
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
