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
    private let screenSize = UIScreen.main.bounds
    private let sectorSideSize = UIScreen.main.bounds.height * 0.8 / 16.0
    
    func setViewDelegate(simulationViewControllerDelegate: SimulationViewControllerDelegate) {
        
        self.simulationViewControllerDelegate = simulationViewControllerDelegate
    }
    
    
    func setMapToView() {
        
        var mapSectors = [MapSector]()
        
        let yPseudoConstraint = screenSize.height * 0.05
        
        let xPseudoConstraint = (screenSize.width - 9 * sectorSideSize) / 2
        
        for mapItem in self.map.mapItems {
            let penalty = SurfaceType.getPenaltyFromSurfaceType(typeString: mapItem.surfaceType!)
            
            let coordinates = CGRect(x: (CGFloat)(mapItem.indexInRow) * sectorSideSize + xPseudoConstraint,
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
        
        var verticies = [Vertex]()
        
        if path != nil {
            
            for (index, node) in path!.pathNodes.enumerated() {
                
                let x = (node as! MapSector).coordinates.midX
                let y = UIScreen.main.bounds.height - ((node as! MapSector).coordinates.midY)
                
                let vertex = Vertex(x: GLfloat(x), y: GLfloat(y), z: 0.0, r: 1.0, g: 0.0, b: 0.0, a: 1.0)
                
                verticies.append(vertex)
                
                if (node as! MapSector).penalty > 3 {
                    
                    // pathNodes.count - index because of the difference between coordinate systems
                    self.simulationViewControllerDelegate?.setEmergencySectorIndex(index: path!.pathNodes.count - 1 - index)
                }
            }
        }
        
        self.simulationViewControllerDelegate?.setVertices(vertices: verticies, sectorSideSize: self.sectorSideSize)
    }
    
    
    func generateRoverPathCoordinates(roverPathSectors: [CGRect], emergencySectorIndex: Int?) -> [CGRect] {
        
        var coordinates = [CGRect]()
        
        let shiftPerTick = roverPathSectors.first!.size.height / 40

        for (index, rect) in roverPathSectors.enumerated() {

            if (index == roverPathSectors.count - 1) || (index == emergencySectorIndex) {
                break
            }
            
            let width = rect.size.width
            let height = rect.size.height
            
            let x = rect.minX
            let y = roverPathSectors.last!.minY -  rect.minY + UIScreen.main.bounds.height * 0.05
                
            coordinates.append(CGRect(x: x, y: y, width: width, height: height))
            
            let direction: Direction
            
            if rect.origin.y > roverPathSectors[index + 1].origin.y {
                direction = .down
            } else if rect.origin.y < roverPathSectors[index + 1].origin.y {
                direction = .up
            } else if rect.origin.x > roverPathSectors[index + 1].origin.x {
                direction = .left
            } else {
                direction = .right
            }
            
            for _ in 0...39 {
                var x = coordinates.last!.minX
                var y = coordinates.last!.minY
                
                switch direction {
                case .up:
                    y -= shiftPerTick
                    
                case .down:
                    y += shiftPerTick
                    
                case .left:
                    x -= shiftPerTick
                    
                case .right:
                    x += shiftPerTick
                }
                
                let newCoordinate = CGRect(x: x, y: y, width: width, height: height)
                
                coordinates.append(newCoordinate)
            }
        }
        
        return coordinates
    }
}
