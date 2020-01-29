//
//  FlightSearchGraph.swift
//  TUITest
//
//  Created by dushantsw on 2020-01-28.
//  Copyright © 2020 Spacetabs Ltd. All rights reserved.
//

import Foundation
import GameKit

/// FlightSearchGraph used Dijkstras algorithm in order to find the cheapest
/// direct or indirect flight from a given location to a given location.
///
/// Time complexity of the search is: O (E + V log V) where V are number of nodes
/// and E are number of connections.
///
/// Creating the graph is a bit complex as it requires to extract distinct nodes and
/// and then creating connections between the node depending on the weight.
///
/// See LocationGraphNode
class FlightSearchGraph {
    private var graph = GKGraph()
    private var graphNodes: [LocationGraphNode] = []
    private(set) var locations: Set<Location>?

    // MARK: - Initializers
    func createGraph(withFlightConnections connections: [FlightConnection]) {
        self.graph = GKGraph()
        self.createAGraphWithFlights(connections)
    }

    // MARK: - Graph search
    public func location(byName name: String) -> Location? {
        return locations?.first(where: { $0.name.caseInsensitiveCompare(name) == .orderedSame })
    }

    public func searchCheapestRoute(from: Location, to: Location) -> Result<Route, Error> {
        guard let fromNode = graphNodes.first(where: { $0.location == from }) else {
            return .failure(FlightSearchGraphError.departureNodeNotFound)
        }
        guard let toNode = graphNodes.first(where: { $0.location == to }) else {
            return .failure(FlightSearchGraphError.arrivalNodeNotFound)
        }
        return searchCheapestRoute(from: fromNode, to: toNode)
    }

    public func searchCheapestRoute(from: GKGraphNode, to: GKGraphNode) -> Result<Route, Error> {
        let path = graph.findPath(from: from, to: to)
        guard !path.isEmpty else {
            return .failure(FlightSearchGraphError.noRouteFound)
        }
        return .success(route(from: path))
    }

    // MARK: - Graph Route
    private func route(from nodes: [GKGraphNode]) -> Route {
        let locations = nodes.compactMap({ ($0 as? LocationGraphNode)?.location })
        let totalCost = Double(costOfTotalTrip(between: nodes))

        // We have a direct flight
        if nodes.count == 2 {
            return Route(from: locations[0], to: locations[1], legs: nil, totalCost: totalCost)
        } else {
            let legs: [Location] = Array(locations[1...(locations.count - 2)])
            return Route(from: locations[0], to: locations[locations.count - 1], legs: legs, totalCost: totalCost)
        }
    }

    private func costOfTotalTrip(between nodes: [GKGraphNode]) -> Float {
        var totalCost: Float = 0.0
        for index in 0..<(nodes.count - 1) {
            totalCost += nodes[index].cost(to: nodes[index + 1])
        }
        return totalCost
    }

    // MARK: - Graph creating
    private func createAGraphWithFlights(_ connections: [FlightConnection]) {
        // Convert each distinct location to a node
        self.locations = getDistinctLocations(from: connections)
        self.graphNodes = locations?.compactMap({ LocationGraphNode(withLocation: $0) }) ?? []

        // Add these nodes to the graph
        graph.add(graphNodes)

        // Add the connection between each node
        connections.forEach({ connection in
            guard let fromNode = self.graphNodes.first(where: { $0.location == connection.from }) else { return }
            guard let toNode = self.graphNodes.first(where: { $0.location == connection.to }) else { return }
            fromNode.addConnection(to: toNode, price: Float(connection.price))
        })
    }

    private func getDistinctLocations(from connections: [FlightConnection]) -> Set<Location> {
        var locations: Set<Location> = Set<Location>(connections.compactMap({ $0.from }))
        connections.compactMap({ $0.to }).forEach({ locations.insert($0) })
        return locations
    }
}
