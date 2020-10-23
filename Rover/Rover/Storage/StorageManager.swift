//
//  StorageManager.swift
//  Rover
//
//  Created by Anton Borisenko on 10/23/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveMap(_ map:DBMapModel) {
        
        try! realm.write {
            realm.add(map)
        }
    }
}
