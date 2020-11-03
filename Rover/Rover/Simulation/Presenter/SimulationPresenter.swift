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
        
        for (index, mapItem) in self.map.mapItems.enumerated() {
            
            if mapItem.row > 0 {
                mapSectors[index].connections.append(Connection(to: mapSectors[index - 9], weight: mapSectors[index - 9].penalty))
            }
            
            if mapItem.row < 15 {
                mapSectors[index].connections.append(Connection(to: mapSectors[index + 9], weight: mapSectors[index + 9].penalty))
            }
            
            if mapItem.indexInRow > 0 {
                mapSectors[index].connections.append(Connection(to: mapSectors[index - 1], weight: mapSectors[index - 1].penalty))
            }
            
            if mapItem.indexInRow < 8 {
                mapSectors[index].connections.append(Connection(to: mapSectors[index + 1], weight: mapSectors[index + 1].penalty))
            }
        }
        
        self.simulationViewControllerDelegate?.setMap(map: mapSectors)
    }
    
    
    func mapWasSet(map: [MapSector]) {
        
        let path = ShortestPathFinder.shortestPath(source: map[4], destination: map[139])
    }
}
