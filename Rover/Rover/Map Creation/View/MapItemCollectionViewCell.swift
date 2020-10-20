//
//  MapItemCollectionViewCell.swift
//  Rover
//
//  Created by Anton Borisenko on 10/20/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

class MapItemCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = String(describing: MapItemCollectionViewCell.self)
    static let nib = UINib(nibName: String(describing: MapItemCollectionViewCell.self), bundle: nil)
    
    var mapItemImage: UIImageView!
    
    func initConstraints() {
        
        NSLayoutConstraint.activate([
            mapItemImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mapItemImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        backgroundColor = .white
        clipsToBounds = true
        
        mapItemImage = UIImageView()
        mapItemImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(mapItemImage)
        
        initConstraints()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
    }
    
    func update(mapItemType: MapItemType) {

        switch mapItemType {
        case .ground:
            return
        
        case .hill:
            return
        
        case .pit:
            return
            
        case .quicksand:
            return
        }
        //mapItemImage.image = image
    }
    

}
