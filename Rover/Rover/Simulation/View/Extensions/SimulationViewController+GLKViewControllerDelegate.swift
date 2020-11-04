//
//  SimulationViewController+.swift
//  Rover
//
//  Created by Anton Borisenko on 11/4/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation
import GLKit
import OpenGLES

extension SimulationViewController: GLKViewControllerDelegate {

    func glkViewControllerUpdate(_ controller: GLKViewController) {

        // Calculating the aspect ratio of the GLKView
        let aspect = fabsf(Float(view.bounds.size.width) / Float(view.bounds.size.height))
        
        // Creating a perspective matrix
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 4.0, 10.0)
        
        effect.transform.projectionMatrix = projectionMatrix
        
        // Creating a matrix that translates six units backwards
        let modelViewMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, -6.0)

        effect.transform.modelviewMatrix = modelViewMatrix
    }
}
