//
//  SimulationPresenterDelegate.swift
//  Rover
//
//  Created by Anton Borisenko on 11/2/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

protocol SimulationPresenterDelegate {
    
    func setViewDelegate(simulationViewControllerDelegate: SimulationViewControllerDelegate)
    func setMapToView()
    func mapWasSet(map: [MapSector])
    func generateRoverPathCoordinates(roverPathSectors: [CGRect], emergencySectorIndex: Int?) -> [CGRect]
}
