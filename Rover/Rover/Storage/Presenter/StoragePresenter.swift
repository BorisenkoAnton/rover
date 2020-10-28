//
//  StoragePresenter.swift
//  Rover
//
//  Created by Anton Borisenko on 10/23/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit
import Firebase

class StoragePresenter {
    
    weak private var storageViewControllerDelegate: StorageViewControllerDelegate?
    
    
    func setViewDelegate(storageViewControllerDelegate: StorageViewControllerDelegate) {
        
        self.storageViewControllerDelegate = storageViewControllerDelegate
    }
    
    
    func getStoredMaps() {
        
        let storedMapsResults = StorageManager.getStoredMaps()
        
        var storedMaps = Array(storedMapsResults)
        
        var storedMapsNames = [String]()
        
        for storedMap in storedMaps {
            
            storedMapsNames.append(storedMap.name)
        }
        
        let latestlocalUpdatesTimestamp = storedMapsResults.max(ofProperty: "timestamp") as Int?

        firestore.collection("maps").whereField("timestamp", isGreaterThan: latestlocalUpdatesTimestamp).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                
                for document in querySnapshot!.documents {
                    do {
                        let map = try DBMapModel(from: document.data())
                        
                        if storedMapsNames.firstIndex(of: map.name) != nil {
                            try realm.write {
                                
                                let local =  storedMaps[storedMapsNames.firstIndex(of: map.name)!]
                                
                                for (index, value) in map.mapItems.enumerated() {
                                    local.mapItems[index] = value
                                }
                                
                                local.timestamp = map.timestamp
                                
                            }
                        }
                    } catch {
                        print("Error while deserializing")
                    }
                }
            }
            
            self.storageViewControllerDelegate?.setArrayOfStoredMaps(storedMaps: storedMaps)
        }
    }
    
    
    func removeMapFromStorage(map: DBMapModel) {
        
        StorageManager.deleteMap(map)
    }
    
    
    func editMap(map: DBMapModel, navigationController: UINavigationController) {
        
        let presentingViewController = (navigationController.presentingViewController as! UINavigationController).viewControllers.first
        
        (presentingViewController as! ViewWithMapController).mapPresenter.loadStoredMap(map: map)
        
        self.storageViewControllerDelegate?.navigate()
    }
    
    
    func createMap(navigationController: UINavigationController) {
        
        let presentingViewController = (navigationController.presentingViewController as! UINavigationController).viewControllers.first
        
        (presentingViewController as! ViewWithMapController).mapPresenter.clearMap()
        
        self.storageViewControllerDelegate?.navigate()
    }
    
    
    func returnToCurrentMap() {
        
        self.storageViewControllerDelegate?.navigate()
    }
    
    
    func changeMapName(map: DBMapModel, newName: String) {
        
        StorageManager.changeMapname(map, newName: newName)
    }
}
