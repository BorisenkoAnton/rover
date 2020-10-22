//
//  MapPresenter.swift
//  Rover
//
//  Created by Anton Borisenko on 10/21/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

class MapPresenter {
    
    weak private var viewWithMapControllerDelegate: ViewWithMapControllerDelegate?
    private var selectedSurfaceType: MapItemType?
    
    func setViewDelegate(viewWithMapControllerDelegate: ViewWithMapControllerDelegate) {
        
        self.viewWithMapControllerDelegate = viewWithMapControllerDelegate
    }
    
    
    func surfaceTypeSelected(selectedType: MapItemType) {

        self.selectedSurfaceType = selectedType
        self.viewWithMapControllerDelegate?.highlightBottomPanelButton(selectedSurfaceType: selectedType)
    }
    
    
    func mapItemSelected(selectedItemIndexPath: IndexPath) {
        
        guard let surfaceType = self.selectedSurfaceType else { return }

        self.viewWithMapControllerDelegate?.setMapItemSurface(indexPath: selectedItemIndexPath, surfaceType: surfaceType)
    }
    
    func generateRandomMap(numberOfMapItems: Int) {
        
        var generatedMap = [MapItemType]()
        let allSurfaceTypes = MapItemType.allCases
        
        for _ in 0..<numberOfMapItems {
            let randomIndex = Int.random(in: 0..<allSurfaceTypes.count)
            
            let surfaceType = allSurfaceTypes[randomIndex]
            
            generatedMap.append(surfaceType)
        }
        
        self.viewWithMapControllerDelegate?.setMapItems(mapItemTypes: generatedMap)
    }
}
