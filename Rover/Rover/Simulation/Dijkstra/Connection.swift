//
//  Connection.swift
//  Rover
//
//  Created by Anton Borisenko on 11/3/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

class Connection {
    
  public let to: Node
  public let weight: Int
  
    
  public init(to node: Node, weight: Int) {

    self.to = node
    self.weight = weight
  }
}
