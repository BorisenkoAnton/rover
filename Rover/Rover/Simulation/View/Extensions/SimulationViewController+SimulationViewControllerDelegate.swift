//
//  SimulationViewController+SimulationViewControllerDelegate.swift
//  Rover
//
//  Created by Anton Borisenko on 11/4/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

extension SimulationViewController: SimulationViewControllerDelegate {
    
    func setSimulationPresenterDelegate(delegate: SimulationPresenterDelegate) {
        
        self.simulationPresenterDelegate = delegate
    }
    
    
    func setMap(map: [MapSector]) {
        
        self.map = map
        
        self.view.setNeedsDisplay()
        
        self.simulationPresenterDelegate?.mapWasSet(map: self.map!)
    }
}

