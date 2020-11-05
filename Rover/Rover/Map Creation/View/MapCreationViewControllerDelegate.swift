//
//  ViewWithMapControllerDelegate.swift
//  Rover
//
//  Created by Anton Borisenko on 10/21/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import RealmSwift

protocol MapCreationViewControllerDelegate: class {
    
    func setMapPresenterDelegate(delegate: MapPresenterDelegate)
    func highlightBottomPanelButton(selectedSurfaceType: SurfaceType)
    func mapItemSurfaceWasSet()
    func reloadMapView()
    func navigateTo(viewController: UIViewController)
    func setMap(map: DBMapModel)
    func setClearMap()
}
