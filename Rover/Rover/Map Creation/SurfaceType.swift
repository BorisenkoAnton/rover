//
//  MapItemType.swift
//  Rover
//
//  Created by Anton Borisenko on 10/20/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

enum SurfaceType: CaseIterable {
    case ground
    case quicksand
    case pit
    case hill
    
    
    static func returnStringValue(surfaceType: SurfaceType) -> String {
        switch surfaceType {
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
    
    
    static func surfaceTypeFromString(typeString: String) -> SurfaceType? {
        
        switch typeString {
        case "ground":
            return .ground
            
        case "hill":
            return .hill
            
        case "pit":
            return .pit
            
        case "quicksand":
            return .quicksand
            
        default:
            return nil
        }
    }
    
    
    static func getPenaltyFromSurfaceType(typeString: String) -> Int? {
        
        let surfaceType = surfaceTypeFromString(typeString: typeString)
        
        var penalty: Int
        
        switch surfaceType {
        case .hill:
            penalty = 2
            
        case .quicksand:
            penalty = 3
            
        case .pit:
            penalty = 999
        
        default:
            penalty = 0
        }
        
        return penalty
    }
}
