//
//  SimulationView.swift
//  Rover
//
//  Created by Anton Borisenko on 10/30/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import GLKit
import OpenGLES

class SimulationView: GLKView {

    var map: [MapSector]?
    var ciContext: CIContext?
    
    override func draw(_ rect: CGRect) {
        
        if self.map != nil {
            for mapSector in self.map! {
                let image = CIImage(cgImage: UIImage(named: mapSector.surfaceImageName)!.cgImage!)
                
                let scale = CGAffineTransform(scaleX: self.contentScaleFactor, y: self.contentScaleFactor)
                
                let drawingRect = mapSector.coordinates.applying(scale)
                
                self.ciContext?.draw(image, in: drawingRect, from: image.extent)
            }
        }
    }
}
