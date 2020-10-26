//
//  StoragePresenter.swift
//  Rover
//
//  Created by Anton Borisenko on 10/23/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

class StoragePresenter {
    
    weak private var storageViewControllerDelegate: StorageViewControllerDelegate?
    
    
    func setViewDelegate(storageViewControllerDelegate: StorageViewControllerDelegate) {
        
        self.storageViewControllerDelegate = storageViewControllerDelegate
    }
    
    
    func getStoredMaps() {
        
        let storedMapsResults = realm.objects(DBMapModel.self)
        
        let storedMaps = Array(storedMapsResults)
        
        self.storageViewControllerDelegate?.setArrayOfStoredMaps(storedMaps: storedMaps)
    }
    
    
    func removeMapFromStorage(map: DBMapModel) {
        
        StorageManager.deleteMap(map)
    }
    
    
    func editMap(map: DBMapModel, navigationController: UINavigationController) {
        
        let viewWithMapVC = navigationController
        
        ((viewWithMapVC.presentingViewController as! UINavigationController).viewControllers.first as! ViewWithMapController).map = map

        ((viewWithMapVC.presentingViewController as! UINavigationController).viewControllers.first as! ViewWithMapController).mapItemsCollectionView.reloadData()
        
        self.storageViewControllerDelegate?.navigate()
    }
}
