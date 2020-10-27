//
//  StorageManager.swift
//  Rover
//
//  Created by Anton Borisenko on 10/23/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import RealmSwift
import Firebase

let realm = try! Realm()

let firestore = Firestore.firestore()

class StorageManager {
    
    static func saveMap(_ map:DBMapModel) {
        
        try! realm.write {
            realm.add(map)
        }
        
        if let mapAsDictionary = map.asDictionary {
            firestore.collection("maps").document(map.name).setData(mapAsDictionary)
        }
    }
    
    
    static func deleteMap(_ map:DBMapModel) {
        
        firestore.collection("maps").document(map.name).delete()
        
        try! realm.write {
            realm.delete(map)
        }
    }
    
    
    static func changeMapname(_ map: DBMapModel, newName: String) {
        
        let mapName = map.name
        
        firestore.collection("maps").document(mapName).updateData(["name": newName])
        
        firestore.collection("maps").document(mapName).getDocument { (document, error) in
            
            if let data = document?.data() {
                print("sfdsfsdf")
                firestore.collection("maps").document(newName).setData(data)
            }
            
            firestore.collection("maps").document(mapName).delete()
        }
        
        try! realm.write {
            map.name = newName
        }
    }
    
    
    static func synchronize() {
        
        
    }
}
