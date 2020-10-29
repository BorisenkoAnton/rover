//
//  ViewWithMapController+ViewWithMapControllerDelegate.swift
//  Rover
//
//  Created by Anton Borisenko on 10/23/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit
import RealmSwift

extension ViewWithMapController: ViewWithMapControllerDelegate {
    
    // Highliting selected surface
    func highlightBottomPanelButton(selectedSurfaceType: SurfaceType) {
        
        for bottomButton in bottomPanelStackView.arrangedSubviews {
            let buttonSurfaceType = (bottomButton as! BottomPanelButton).mapItemType
            
            var imageName: String
            
            if buttonSurfaceType == selectedSurfaceType {
                imageName = SurfaceType.returnStringValue(surfaceType:buttonSurfaceType!) + "_highlighted"
            } else {
                imageName = SurfaceType.returnStringValue(surfaceType:buttonSurfaceType!)
            }
            
            if let image = UIImage(named: "\(imageName)") {
                (bottomButton as! BottomPanelButton).setImage(image, for: .normal)
            }
        }
    }
    
    // Set surface type for one map item (one content view cell)
    func setMapItemSurface(indexPath: IndexPath, surfaceType: SurfaceType) {
        
        try! realm.write {
            let mapItem = DBMapItem()

            mapItem.surfaceType = SurfaceType.returnStringValue(surfaceType: surfaceType)
            
            self.map.mapItems.replace(index: indexPath.row, object: mapItem)

            self.map.timestamp = Int(Date().timeIntervalSince1970)
            
            self.mapItemsCollectionView.reloadData()
        }
    }
    
    // Set surface types for all map
    func setAllMapItemsSurfaceTypes(mapItemSurfaces: [SurfaceType]) {
        
        StorageManager.setMapItemsSurfaceTypes(map: self.map, surfaces: mapItemSurfaces)
        
        self.mapItemsCollectionView.reloadData()
    }
    
    
    func navigateTo(viewController: UIViewController) {
        
        self.navigationController?.present(viewController, animated: true)
    }
    
    
    func setMap(map: DBMapModel) {
        
        self.map = map
        
        self.mapItemsCollectionView.reloadData()
    }
    
    // Map with no surfaces
    func setClearMap() {
        
        self.map = DBMapModel()
        
        self.map.mapItems.append(objectsIn: [DBMapItem](repeating: DBMapItem(), count: itemsPerRow * rowsCount))
        
        self.mapItemsCollectionView.reloadData()
    }
}
