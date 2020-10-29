//
//  ViewWithMapControllerDelegate.swift
//  Rover
//
//  Created by Anton Borisenko on 10/21/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import RealmSwift

protocol MapCreationViewControllerDelegate: class {
    
    func highlightBottomPanelButton(selectedSurfaceType: SurfaceType)
    func setMapItemSurface(indexPath: IndexPath, surfaceType: SurfaceType)
    func reloadMapView()
    func navigateTo(viewController: UIViewController)
    func setMap(map: DBMapModel)
    func setClearMap()
}
