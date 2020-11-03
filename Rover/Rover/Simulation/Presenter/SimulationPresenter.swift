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
        
        let screenSize = UIScreen.main.bounds
        
        let xPseudoConstraint = screenSize.width * 0.05
        
        let sectorSideSize = screenSize.width / 9.0
        
        let yPseudoConstraint = screenSize.height * 0.05
        
        for mapItem in self.map.mapItems {
            let penalty = SurfaceType.getPenaltyFromSurfaceType(typeString: mapItem.surfaceType!)
            
            let coordinates = CGRect(x: (CGFloat)(mapItem.indexInRow) * sectorSideSize,
                                     y: (CGFloat)(15 - mapItem.row) * sectorSideSize + yPseudoConstraint,
                                     width: sectorSideSize,
                                     height: sectorSideSize
            )
            
            let mapSector = MapSector(coordinates: coordinates, penalty: penalty!, surfaceImageName: mapItem.surfaceType!)
            
            mapSectors.append(mapSector)
        }
        
        self.simulationViewControllerDelegate?.setMap(map: mapSectors)
    }
}
