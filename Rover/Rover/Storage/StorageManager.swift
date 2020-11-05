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
        
        try! realm.write {
            
            map.name = mapName
            
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
    
    // Getting locally stored map
    static func getStoredMaps() -> Results<DBMapModel> {
        
        return realm.objects(DBMapModel.self)
    }
    
    
    static func changeMapName(_ map: DBMapModel, newName: String) {
        
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
    
    
    static func setMapItemSurface(map: DBMapModel, indexPath: IndexPath, surfaceType: String) {
        
        let mapItemToUpdate = map.mapItems[indexPath.row]
        
        let mapItem = DBMapItem()
        
        mapItem.surfaceType = surfaceType
        mapItem.indexInRow = mapItemToUpdate.indexInRow
        mapItem.row = mapItemToUpdate.row
        
        try! realm.write {

            map.mapItems.replace(index: indexPath.row, object: mapItem)
        }
    }
    
    
    static func updateMapInCloud(map: DBMapModel) {
        
        firestore.collection("maps").document(map.name).updateData(map.asDictionary!)
    }
    
    
    static func updateMapTimestamp(map: DBMapModel) {
        
        try! realm.write {
            map.timestamp = Int(Date().timeIntervalSince1970)
        }
    }
    
    
    // Setting surface types for all map
    static func setSurfacesForFullMap(map: DBMapModel, surfaces: [SurfaceType], itemsPerRow: Int) {
        
        let mapItems = List<DBMapItem>()
        
        var rowIndex = 0
        var indexInRow = 0
        
        for (index, mapItemSurfaceType) in surfaces.enumerated() {
            
            if (index != 0) && (index % itemsPerRow) == 0 {
                rowIndex += 1
                indexInRow = 0
            }
            
            let mapItem = DBMapItem()
            
            mapItem.surfaceType = SurfaceType.returnStringValue(surfaceType: mapItemSurfaceType)
            mapItem.row = rowIndex
            mapItem.indexInRow = indexInRow
            
            mapItems.append(mapItem)
            
            indexInRow += 1
        }
            
        try! realm.write {
            map.mapItems.removeAll()
            
            map.mapItems.append(objectsIn: mapItems)
        }
    }
    
    // Syncronize cloud storage with local by comparing timestamp of last local chanes and last cloud changes
    static func syncronize(storedMaps: [DBMapModel], storedMapsNames: [String], latestLocalTimestamp: Int?, completion: @escaping () -> Void) {
        
        firestore.collection("maps").whereField("timestamp", isGreaterThan: latestLocalTimestamp).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                
                for document in querySnapshot!.documents {
                    do {
                        let map = try DBMapModel(from: document.data())
                        
                        if storedMapsNames.firstIndex(of: map.name) != nil {
                            try realm.write {
                                
                                let localStoredMap =  storedMaps[storedMapsNames.firstIndex(of: map.name)!]
                                
                                for (index, value) in map.mapItems.enumerated() {
                                    localStoredMap.mapItems[index] = value
                                }
                                
                                localStoredMap.timestamp = map.timestamp
                                
                            }
                        }
                    } catch {
                        print("Error while deserializing")
                    }
                }
            }
            
            completion()
        }
    }
}

