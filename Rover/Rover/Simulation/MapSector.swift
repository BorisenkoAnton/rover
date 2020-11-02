//
//  MapSector.swift
//  Rover
//
//  Created by Anton Borisenko on 11/2/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

class MapSector {

    let coordinates: CGRect
    let surfaceImageName: String
    let penalty: Int
    
    
    init(coordinates: CGRect, penalty: Int, surfaceImageName: String) {

        self.coordinates = coordinates
        self.surfaceImageName = surfaceImageName
        self.penalty = penalty
    }
}
