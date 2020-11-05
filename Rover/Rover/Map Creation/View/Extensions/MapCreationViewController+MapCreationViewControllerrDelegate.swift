//
//  ViewWithMapController+ViewWithMapControllerDelegate.swift
//  Rover
//
//  Created by Anton Borisenko on 10/23/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit
import RealmSwift

extension MapCreationViewController: MapCreationViewControllerDelegate {
    
    func setMapPresenterDelegate(delegate: MapPresenterDelegate) {
        
        self.mapPresenterDelegate = delegate
    }
    
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
    func mapItemSurfaceWasSet() {
            
        self.mapItemsCollectionView.reloadData()
    }
    
    // Set surface types for all map
    func reloadMapView() {
        
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
