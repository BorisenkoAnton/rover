//
//  Path.swift
//  Rover
//
//  Created by Anton Borisenko on 11/3/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

class Path {
    
    public let cumulativeWeight: Int
    public let node: Node
    public let previousPath: Path?
  
    
    init(to node: Node, via connection: Connection? = nil, previousPath path: Path? = nil) {
        
        if let previousPath = path, let viaConnection = connection {
            self.cumulativeWeight = viaConnection.weight + previousPath.cumulativeWeight
        } else {
            self.cumulativeWeight = 0
        }
        
        self.node = node
        self.previousPath = path
    }
}
