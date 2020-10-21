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
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = .black
        clipsToBounds = true
        
        mapItemImage = UIImageView(frame: CGRect.zero)
        mapItemImage.contentMode = .scaleToFill
        mapItemImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(mapItemImage)
        
        initConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initConstraints() {
        
        NSLayoutConstraint.activate([
            mapItemImage.topAnchor.constraint(equalTo: self.topAnchor),
            mapItemImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mapItemImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mapItemImage.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
    }
    
    
    func update(mapItemType: MapItemType) {

        let imageName = mapItemType.returnStringValue(itemType: mapItemType)
        
        if let image = UIImage(named: "\(imageName)") {

            self.mapItemImage.image = image
        }
    }
    

}
