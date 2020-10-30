//
//  StoragePresenterDelegate.swift
//  Rover
//
//  Created by Anton Borisenko on 10/30/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

protocol StoragePresenterDelegate: class {
    
    func setViewDelegate(storageViewControllerDelegate: StorageViewControllerDelegate)
    func getStoredMaps()
    func removeMapFromStorage(map: DBMapModel)
    func editMap(map: DBMapModel, navigationController: UINavigationController)
    func simulateMap(map: DBMapModel, navigationController: UINavigationController)
    func createMap(navigationController: UINavigationController)
    func returnToCurrentMap()
    func changeMapName(map: DBMapModel, newName: String)
}
