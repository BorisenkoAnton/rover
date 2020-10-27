//
//  DBMapModel.swift
//  Rover
//
//  Created by Anton Borisenko on 10/23/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import RealmSwift

class DBMapModel: Object, Codable {
    
    @objc dynamic var name = ""
    
    var mapItems = List<DBMapItem>()
    var asDictionary: [String: Any]? {
      guard let data = try? JSONEncoder().encode(self) else { return nil }
      return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    convenience init(name: String, mapItems: List<DBMapItem>) {
        
        self.init()
        
        self.name = name
    }
}


class DBMapItem: Object, Codable {
    
    @objc dynamic var surfaceType: String?
    @objc dynamic var sectionIndex = 0
    @objc dynamic var indexInSection = 0
    
    var indexPath: IndexPath {
        return IndexPath(item: indexInSection, section: sectionIndex)
    }
}
