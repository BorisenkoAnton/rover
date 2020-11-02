//
//  SimulationViewControllerDelegate.swift
//  Rover
//
//  Created by Anton Borisenko on 11/2/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

protocol SimulationViewControllerDelegate: class {

    func setMap(map: [MapSector])
    func setSimulationPresenterDelegate(delegate: SimulationPresenterDelegate)
}
