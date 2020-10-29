//
//  ViewWithMapController+UICollectionView.swift
//  Rover
//
//  Created by Anton Borisenko on 10/23/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

extension MapCreationViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return map.mapItems.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapItemCollectionViewCell.reuseID, for: indexPath) as? MapItemCollectionViewCell else {
                fatalError("Wrong cell")
        }
        
        cell.mapItemImage.image = nil
        
        let mapItem = self.map.mapItems[indexPath.item]

        if let mapItemSurfaceType = mapItem.surfaceType {
            
            cell.update(mapItemType: SurfaceType.surfaceTypeFromString(typeString: mapItemSurfaceType))
        }
        
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        mapPresenter.mapItemSelected(selectedItemIndexPath: indexPath)
    }
}
