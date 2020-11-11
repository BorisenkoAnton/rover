//
//  StorageViewController+StorageViewControllerDelegate.swift
//  Rover
//
//  Created by Anton Borisenko on 10/23/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

extension StorageViewController: StorageViewControllerDelegate {
    
    func setStoragePresenterDelegate(delegate: StoragePresenterDelegate) {
        
        self.storagePresenterDelegate = delegate
    }
    
    
    func setArrayOfStoredMaps(storedMaps: Array<DBMapModel>) {
        
        self.storedMaps = storedMaps
        
        self.tableWithStoredMapsView.reloadData()
    }
    
    
    func returnToMapCreation() {

        self.dismiss(animated: true)
    }
    
    
    func navigateTo(viewController: UIViewController) {
        
        self.navigationController?.present(viewController, animated: true)
    }
}
