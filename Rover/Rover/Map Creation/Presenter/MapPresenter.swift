//
//  MapPresenter.swift
//  Rover
//
//  Created by Anton Borisenko on 10/21/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import RealmSwift

class MapPresenter: MapPresenterDelegate {
    
    weak private var mapCreationViewControllerDelegate: MapCreationViewControllerDelegate?
    private var selectedSurfaceType: SurfaceType?
    
    
    func setViewDelegate(viewWithMapControllerDelegate: MapCreationViewControllerDelegate) {
        
        self.mapCreationViewControllerDelegate = viewWithMapControllerDelegate
    }
    
    
    func surfaceTypeSelected(selectedType: SurfaceType) {

        self.selectedSurfaceType = selectedType
        self.mapCreationViewControllerDelegate?.highlightBottomPanelButton(selectedSurfaceType: selectedType)
    }
    
    
    func mapItemSelected(selectedItemIndexPath: IndexPath) {
        
        guard let surfaceType = self.selectedSurfaceType else { return }

        self.mapCreationViewControllerDelegate?.setMapItemSurface(indexPath: selectedItemIndexPath, surfaceType: surfaceType)
    }
    
    
    func generateRandomMap(neededNumberOfMapItems: Int, map: DBMapModel, itemsPerRow: Int) {
        
        var generatedMap = [SurfaceType]()
        let allSurfaceTypes = SurfaceType.allCases
        
        for _ in 0..<neededNumberOfMapItems {
            let randomIndex = Int.random(in: 0..<allSurfaceTypes.count)
            
            let surfaceType = allSurfaceTypes[randomIndex]
            
            generatedMap.append(surfaceType)
        }
        
        StorageManager.setSurfacesForFullMap(map: map, surfaces: generatedMap, itemsPerRow: itemsPerRow)
        
        self.mapCreationViewControllerDelegate?.reloadMapView()
    }
    
    
    func storageButtonPressed() {
        
        let storageVC = SceneFactory.storageScene()
        
        storageVC.modalPresentationStyle = .fullScreen
        
        self.mapCreationViewControllerDelegate?.navigateTo(viewController: storageVC)
    }
    
    
    func saveMap(map: DBMapModel) {
        
        StorageManager.saveMap(map)
    }
    
    
    func loadStoredMap(map: DBMapModel) {
        
        self.mapCreationViewControllerDelegate?.setMap(map: map)
    }
    
    
    func clearMap() {
        
        self.mapCreationViewControllerDelegate?.setClearMap()
    }
    
    
    func mapWasChanged(map: DBMapModel) {
        
        if map.name != "" {
            
            StorageManager.updateMapInCloud(map: map)
        }
    }
}
