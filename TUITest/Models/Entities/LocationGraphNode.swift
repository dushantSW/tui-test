//
//  LocationGraphNode.swift
//  TUITest
//
//  Created by dushantsw on 2020-01-28.
//  Copyright © 2020 Spacetabs Ltd. All rights reserved.
//

import GameKit

/// LocationGraphNode represent a location as node in the Dijkstras graph.
///
/// As the gamekit does not provides weighted connections out-of-box. This
/// class extends the functionality to add cost to nodes connection.
class LocationGraphNode: GKGraphNode {
    let location: Location
    var price: [GKGraphNode: Float] = [:]

    // MARK: - Initializers
    init(withLocation location: Location) {
        self.location = location
        super.init()
    }

    required init?(coder: NSCoder) {
        self.location = .southPole()
        super.init(coder: coder)
    }

    override func cost(to node: GKGraphNode) -> Float {
        return price[node] ?? 0
    }

    func addConnection(to node: GKGraphNode, bidirectional: Bool = false, price: Float) {
        self.addConnections(to: [node], bidirectional: bidirectional)
        self.price[node] = price
        if bidirectional { (node as? LocationGraphNode)?.price[self] = price }
    }
}
