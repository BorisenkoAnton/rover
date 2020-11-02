//
//  SimulationViewController.swift
//  Rover
//
//  Created by Anton Borisenko on 10/30/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit
import GLKit
import OpenGLES


class SimulationViewController: GLKViewController, SimulationViewControllerDelegate {
    
    var simulationPresenterDelegate: SimulationPresenterDelegate?
    
    
    override func loadView() {
        
        setupGL()
        self.simulationPresenterDelegate?.setMapToView()
    }

    
    func setSimulationPresenterDelegate(delegate: SimulationPresenterDelegate) {
        
        self.simulationPresenterDelegate = delegate
    }
    

    private func setupGL() {
        
        self.view = SimulationView()
        
        if let eaglContext = EAGLContext(api: .openGLES3) {
            
            (self.view as! SimulationView).context = eaglContext
            (self.view as! SimulationView).ciContext = CIContext(eaglContext: eaglContext)
        }
    }
    
    
    func setMap(map: [MapSector]) {
        
        (self.view as! SimulationView).map = map
        
        self.view.setNeedsDisplay()
    }
}
