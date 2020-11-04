//
//  Array+size.swift
//  Rover
//
//  Created by Anton Borisenko on 11/4/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

extension Array {
    
    func size() -> Int {
        
        return MemoryLayout<Element>.stride * self.count
    }
}
