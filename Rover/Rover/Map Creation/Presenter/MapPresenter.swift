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
    private var selectedSurfaceType: SurfaceType?
    
    
    func setViewDelegate(viewWithMapControllerDelegate: ViewWithMapControllerDelegate) {
        
        self.viewWithMapControllerDelegate = viewWithMapControllerDelegate
    }
    
    
    func surfaceTypeSelected(selectedType: SurfaceType) {

        self.selectedSurfaceType = selectedType
        self.viewWithMapControllerDelegate?.highlightBottomPanelButton(selectedSurfaceType: selectedType)
    }
    
    
    func mapItemSelected(selectedItemIndexPath: IndexPath) {
        
        guard let surfaceType = self.selectedSurfaceType else { return }

        self.viewWithMapControllerDelegate?.setMapItemSurface(indexPath: selectedItemIndexPath, surfaceType: surfaceType)
    }
    
    
    func generateRandomMap(numberOfMapItems: Int) {
        
        var generatedMap = [SurfaceType]()
        let allSurfaceTypes = SurfaceType.allCases
        
        for _ in 0..<numberOfMapItems {
            let randomIndex = Int.random(in: 0..<allSurfaceTypes.count)
            
            let surfaceType = allSurfaceTypes[randomIndex]
            
            generatedMap.append(surfaceType)
        }
        
        self.viewWithMapControllerDelegate?.setAllMapItemsSurfaceTypes(mapItemSurfaceTypes: generatedMap)
    }
    
    
    func storageButtonPressed() {
        
        let storageVC = SceneFactory.createStorageViewController()
        
        storageVC.modalPresentationStyle = .fullScreen
        
        self.viewWithMapControllerDelegate?.navigateTo(viewController: storageVC)
    }
    
    
    func saveMap(map: [MapItem]) {
        
        let mapToSave = DBMapModel()
        
        mapToSave.name = "test"
        
        for (row, mapItem) in map.enumerated() {
            let mapItemToSave = DBMapItem()
            
            mapItemToSave.sectionIndex = 0
            mapItemToSave.indexInSection = row
            
            if mapItem.mapItemType != nil {
                mapItemToSave.surfaceType = mapItem.mapItemType?.returnStringValue(surfaceType: mapItem.mapItemType!)
            }
            
            mapToSave.mapItems.append(mapItemToSave)
        }
        
        StorageManager.saveMap(mapToSave)
    }
}
