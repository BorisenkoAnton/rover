//
//  StorageViewControllerDelegate.swift
//  Rover
//
//  Created by Anton Borisenko on 10/23/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

protocol StorageViewControllerDelegate: class {
    
    func setArrayOfStoredMaps(storedMaps: Array<DBMapModel>)
}
