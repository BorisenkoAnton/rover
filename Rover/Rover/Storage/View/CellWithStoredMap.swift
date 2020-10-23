//
//  CellWithStoredMap.swift
//  Rover
//
//  Created by Anton Borisenko on 10/23/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

class CellWithStoredMap: UITableViewCell {
    
    static let reuseID = String(describing: CellWithStoredMap.self)
    
    var mapNameLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.mapNameLabel = UILabel()
        
        self.mapNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mapNameLabel.textAlignment = .center
        
        self.addSubview(mapNameLabel)
        
        initConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update(mapName: String) {
        
        self.mapNameLabel.text = mapName
    }
    
    
    func initConstraints() {
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 50.0),
            mapNameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            mapNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mapNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mapNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
}
