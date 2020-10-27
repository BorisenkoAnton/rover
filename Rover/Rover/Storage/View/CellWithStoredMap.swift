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

    var mapNameTextField: UITextField!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.mapNameTextField = UITextField()
        
        self.mapNameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.mapNameTextField.textAlignment = .center
        
        self.addSubview(mapNameTextField)
        
        initConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update(mapName: String, textfieldTag: Int) {
        
        self.mapNameTextField.text = mapName
        self.mapNameTextField.tag = textfieldTag
    }
    
    
    func initConstraints() {
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 50.0),
            mapNameTextField.topAnchor.constraint(equalTo: self.topAnchor),
            mapNameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mapNameTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mapNameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
}
