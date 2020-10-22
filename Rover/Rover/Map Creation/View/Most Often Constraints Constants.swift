//
//  Most Often Constraints Constants.swift
//  Rover
//
//  Created by Anton Borisenko on 10/22/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

enum MostOftenConstraintsConstants {

    case minimumSpacing
    case defaultSpacing
    case top
    case bottom
    case leading
    case trailing
    
    var cgfloatValue: CGFloat {
        switch self {
        case .minimumSpacing:
            return 1.0
        case .top:
            return 20.0
        case .bottom:
            return 20.0
        case .leading:
            return 20.0
        case .trailing:
            return 20.0
        case .defaultSpacing:
            return 8.0
        }
    }
}
