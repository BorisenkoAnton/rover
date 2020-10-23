//
//  ViewWithMapControllerDelegate.swift
//  Rover
//
//  Created by Anton Borisenko on 10/21/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

protocol ViewWithMapControllerDelegate: class {
    
    func highlightBottomPanelButton(selectedSurfaceType: SurfaceType)
    func setMapItemSurface(indexPath: IndexPath, surfaceType: SurfaceType)
    func setAllMapItemsSurfaceTypes(mapItemSurfaceTypes: [SurfaceType])
    func navigateTo(viewController: UIViewController)
}
