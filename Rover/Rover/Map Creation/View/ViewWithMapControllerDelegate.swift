//
//  ViewWithMapControllerDelegate.swift
//  Rover
//
//  Created by Anton Borisenko on 10/21/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

protocol ViewWithMapControllerDelegate: class {
    
    func highlightBottomPanelButton(selectedSurfaceType: MapItemType)
    func setMapItemSurface(indexPath: IndexPath, surfaceType: MapItemType)
    func setMapItems(mapItemTypes: [MapItemType])
}
