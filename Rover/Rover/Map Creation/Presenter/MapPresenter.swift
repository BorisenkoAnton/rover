//
//  MapPresenter.swift
//  Rover
//
//  Created by Anton Borisenko on 10/21/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

class MapPresenter {
    
    weak private var viewWithMapControllerDelegate: ViewWithMapControllerDelegate?
    private var selectedSurfaceType: MapItemType?
    
    func setViewDelegate(viewWithMapControllerDelegate: ViewWithMapControllerDelegate) {
        
        self.viewWithMapControllerDelegate = viewWithMapControllerDelegate
    }
    
    
    func surfaceTypeSelected(selectedType: MapItemType) {
        
        self.selectedSurfaceType = selectedType
    }
}
