//
//  MapItemType.swift
//  Rover
//
//  Created by Anton Borisenko on 10/20/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

enum MapItemType: CaseIterable {
    case ground
    case quicksand
    case pit
    case hill
    
    func returnStringValue(itemType: MapItemType) -> String {
        switch itemType {
        case .ground:
            return "ground"
        
        case .hill:
            return "hill"
            
        case .pit:
            return "pit"
            
        case .quicksand:
            return "quicksand"
        }
    }
}
