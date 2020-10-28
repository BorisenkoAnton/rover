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
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "ddMMyyyyHHmmss"
        
        let mapName = "map" + dateFormatter.string(from: Date())
        
        map.name = mapName
        
        try! realm.write {
            
            realm.add(map)
        }
        
        if let mapAsDictionary = map.asDictionary {

            firestore.collection("maps").document(mapName).setData(mapAsDictionary)
        }
    }
    
    
    static func deleteMap(_ map:DBMapModel) {
        
        firestore.collection("maps").document(map.name).delete()
        
        try! realm.write {
            realm.delete(map)
        }
    }
    
    
    static func getStoredMaps() -> Results<DBMapModel> {
        
        return realm.objects(DBMapModel.self)
    }
    
    
    static func changeMapname(_ map: DBMapModel, newName: String) {
        
        let mapName = map.name
        
        firestore.collection("maps").document(mapName).updateData(["name": newName])
        
        // There is not ability to change document name in Firestore, that's why we replace old document whith newly created
        firestore.collection("maps").document(mapName).getDocument { (document, error) in
            
            if let data = document?.data() {
                firestore.collection("maps").document(newName).setData(data)
            }
            
            firestore.collection("maps").document(mapName).delete()
        }
        
        try! realm.write {
            map.name = newName
        }
    }
    
    
    static func updateMapInCloud(map: DBMapModel) {
        
        firestore.collection("maps").document(map.name).updateData(map.asDictionary!)
    }
}

