//
//  StorageViewController+StorageViewControllerDelegate.swift
//  Rover
//
//  Created by Anton Borisenko on 10/23/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

extension StorageViewController: StorageViewControllerDelegate {
    
    func setArrayOfStoredMaps(storedMaps: Array<DBMapModel>) {
        
        self.storedMaps = storedMaps
        
        self.tableWithStoredMapsView.reloadData()
    }
}
