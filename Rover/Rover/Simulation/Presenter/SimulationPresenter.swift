//
//  SimulationPresenter.swift
//  Rover
//
//  Created by Anton Borisenko on 11/2/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

class SimulationPresenter: SimulationPresenterDelegate {
    
    weak private var simulationViewControllerDelegate: SimulationViewControllerDelegate?
    var map: DBMapModel!
    
    
    func setViewDelegate(simulationViewControllerDelegate: SimulationViewControllerDelegate) {
        
        self.simulationViewControllerDelegate = simulationViewControllerDelegate
    }
    
    
    func setMapToView() {
        
        var mapSectors = [MapSector]()
        
        for mapItem in self.map.mapItems {
            let penalty = SurfaceType.getPenaltyFromSurfaceType(typeString: mapItem.surfaceType!)
            
            let coordinates = CGRect(x: (CGFloat)(mapItem.indexInRow * 50), y: (CGFloat)(mapItem.row * 50), width: 50.0, height: 50.0)
            
            let mapSector = MapSector(coordinates: coordinates, penalty: penalty!, surfaceImageName: mapItem.surfaceType!)
            
            mapSectors.append(mapSector)
        }
        
        self.simulationViewControllerDelegate?.setMap(map: mapSectors)
    }
}
