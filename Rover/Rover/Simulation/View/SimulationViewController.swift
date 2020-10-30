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

class SimulationViewController: GLKViewController {
    
    override func loadView() {
        
        self.view = SimulationView()
    }
}
