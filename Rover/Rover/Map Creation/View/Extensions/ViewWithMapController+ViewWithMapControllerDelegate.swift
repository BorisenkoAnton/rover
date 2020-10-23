//
//  ViewWithMapController+ViewWithMapControllerDelegate.swift
//  Rover
//
//  Created by Anton Borisenko on 10/23/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

extension ViewWithMapController: ViewWithMapControllerDelegate {
    
    func highlightBottomPanelButton(selectedSurfaceType: SurfaceType) {
        
        for bottomButton in bottomPanelStackView.arrangedSubviews {
            let buttonSurfaceType = (bottomButton as! BottomPanelButton).mapItemType
            
            var imageName: String
            
            if buttonSurfaceType == selectedSurfaceType {
                imageName = buttonSurfaceType!.returnStringValue(surfaceType:buttonSurfaceType!) + "_highlighted"
            } else {
                imageName = buttonSurfaceType!.returnStringValue(surfaceType:buttonSurfaceType!)
            }
            
            if let image = UIImage(named: "\(imageName)") {
                (bottomButton as! BottomPanelButton).setImage(image, for: .normal)
            }
        }
    }
    
    // Set surface type for one map item (one content view cell)
    func setMapItemSurface(indexPath: IndexPath, surfaceType: SurfaceType) {
        
        self.mapItems[indexPath.row].mapItemType = surfaceType
        
        self.mapItemsCollectionView.reloadData()
    }
    
    // Set surface types for all map
    func setAllMapItemsSurfaceTypes(mapItemSurfaceTypes: [SurfaceType]) {
        
        for (index, mapItemType) in mapItemSurfaceTypes.enumerated() {
            self.mapItems[index].mapItemType = mapItemType
        }
        
        self.mapItemsCollectionView.reloadData()
    }
    
    
    func navigateTo(viewController: UIViewController) {
        
        self.navigationController?.present(viewController, animated: true)
    }
}
