//
//  StoragePresenter.swift
//  Rover
//
//  Created by Anton Borisenko on 10/23/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit
import Firebase

class StoragePresenter: StoragePresenterDelegate {
    
    weak private var storageViewControllerDelegate: StorageViewControllerDelegate?
    
    
    func setViewDelegate(storageViewControllerDelegate: StorageViewControllerDelegate) {
        
        self.storageViewControllerDelegate = storageViewControllerDelegate
    }
    
    
    func getStoredMaps() {
        
        let storedMapsResults = StorageManager.getStoredMaps()
        
        let storedMaps = Array(storedMapsResults)
        
        var storedMapsNames = [String]()
        
        for storedMap in storedMaps {
            
            storedMapsNames.append(storedMap.name)
        }
        
        let latestlocalUpdatesTimestamp = storedMapsResults.max(ofProperty: "timestamp") as Int?

        StorageManager.syncronize(storedMaps: storedMaps, storedMapsNames: storedMapsNames, latestLocalTimestamp: latestlocalUpdatesTimestamp) {
            
            self.storageViewControllerDelegate?.setArrayOfStoredMaps(storedMaps: storedMaps)
        }
    }
    
    
    func removeMapFromStorage(map: DBMapModel) {
        
        StorageManager.deleteMap(map)
    }
    
    
    func editMap(map: DBMapModel, navigationController: UINavigationController) {
        
        let presentingViewController = (navigationController.presentingViewController as! UINavigationController).viewControllers.first
        
        (presentingViewController as! MapCreationViewController).mapPresenterDelegate?.loadStoredMap(map: map)
        
        self.storageViewControllerDelegate?.navigate()
    }
    
    
    func createMap(navigationController: UINavigationController) {
        
        let presentingViewController = (navigationController.presentingViewController as! UINavigationController).viewControllers.first
        
        (presentingViewController as! MapCreationViewController).mapPresenterDelegate?.clearMap()
        
        self.storageViewControllerDelegate?.navigate()
    }
    
    
    func returnToCurrentMap() {
        
        self.storageViewControllerDelegate?.navigate()
    }
    
    
    func changeMapName(map: DBMapModel, newName: String) {
        
        StorageManager.changeMapName(map, newName: newName)
    }
}
