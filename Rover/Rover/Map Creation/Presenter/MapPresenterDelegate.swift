//
//  MapPresenterDelegate.swift
//  Rover
//
//  Created by Anton Borisenko on 10/30/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

protocol MapPresenterDelegate: class {
    
    func setViewDelegate(viewWithMapControllerDelegate: MapCreationViewControllerDelegate)
    func surfaceTypeSelected(selectedType: SurfaceType)
    func mapItemSelected(map: DBMapModel, indexPath: IndexPath)
    func generateRandomMap(neededNumberOfMapItems: Int, map: DBMapModel, itemsPerRow: Int)
    func storageButtonPressed()
    func saveMap(map: DBMapModel)
    func loadStoredMap(map: DBMapModel)
    func clearMap()
    func mapWasChanged(map: DBMapModel)
}
