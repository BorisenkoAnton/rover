//
//  ShortestPathFinder.swift
//  Rover
//
//  Created by Anton Borisenko on 11/3/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

class ShortestPathFinder {
    
    static func shortestPath(source: Node, destination: Node) -> Path? {
        
        var frontier: [Path] = [] {
            // The frontier has to be always ordered
            didSet { frontier.sort { return $0.cumulativeWeight < $1.cumulativeWeight } }
        }

        // The frontier is made by a path that starts nowhere and ends in the source
        frontier.append(Path(to: source))

        while !frontier.isEmpty {
            // Getting the cheapest path available
            let cheapestPathInFrontier = frontier.removeFirst()
            
            // Making sure we haven't visited the node already
            guard !cheapestPathInFrontier.node.visited else { continue }

            if cheapestPathInFrontier.node === destination {
                // Found the cheapest path
                return cheapestPathInFrontier
            }

            cheapestPathInFrontier.node.visited = true

            for connection in cheapestPathInFrontier.node.connections where !connection.to.visited {
                frontier.append(Path(to: connection.to, via: connection, previousPath: cheapestPathInFrontier))
            }
        }
        
        return nil // we didn't find a path
    }
}
