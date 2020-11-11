//
//  SimulationViewController+SimulationViewControllerDelegate.swift
//  Rover
//
//  Created by Anton Borisenko on 11/4/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation
import GLKit

extension SimulationViewController: SimulationViewControllerDelegate {
    
    func setSimulationPresenterDelegate(delegate: SimulationPresenterDelegate) {
        
        self.simulationPresenterDelegate = delegate
    }
    
    
    func setMap(map: [MapSector]) {
        
        self.map = map
        
        self.simulationPresenterDelegate?.mapWasSet(map: self.map!)
    }
    
    
    func setVertices(vertices: [Vertex], sectorSideSize: CGFloat) {
        
        var translatedVertices = [Vertex]()
        
        var roverPathSectors = [CGRect]()
        
        for vertex in vertices.reversed() {
            let sector = CGRect(x: CGFloat(vertex.x) - sectorSideSize / 2, y: CGFloat(vertex.y) - sectorSideSize / 2, width: sectorSideSize, height: sectorSideSize)
            
            roverPathSectors.append(sector)
        }
        
        self.roverPathSectors = roverPathSectors
        
        for (index, vertex) in vertices.enumerated() {
            
            // Translating view coordinates to GL coordinates
            var translatedVertex = vertex
            
            let translatedX: GLfloat = -1.0 + 2.0 * (vertex.x / GLfloat(self.view.bounds.width))
            let translatedY: GLfloat = 1.0 - 2.0 * (vertex.y / GLfloat(self.view.bounds.height))

            translatedVertex.x = translatedX
            translatedVertex.y = translatedY

            translatedVertices.append(translatedVertex)

            if (index != 0) && (index != vertices.count - 1) {

                self.indices.append(GLubyte(index))
            }

            self.indices.append(GLubyte(index))
        }
        
        self.vertices = translatedVertices
        
        self.setupVertexBuffer()
        
        self.view.setNeedsDisplay()
    }
    
    
    func setEmergencySectorIndex(index: Int) {
            
        self.emergencySectorIndex = index
    }
}
