//
//  ViewController.swift
//  Rover
//
//  Created by Anton Borisenko on 10/20/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

class ViewWithMapController: UIViewController {

    var mapItemsCollectionView: UICollectionView!
    
    var mapItems = [MapItem]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mapItemsCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewLayout())
        mapItemsCollectionView.backgroundColor = .white
        mapItemsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapItemsCollectionView)
    }


}

// MARK: UICollectionViewDataSource & UICollectionViewDelegate
extension ViewWithMapController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return mapItems.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapItemCollectionViewCell.reuseID, for: indexPath) as? MapItemCollectionViewCell else {
                fatalError("Wrong cell")
        }
        
        let mapItem = mapItems[indexPath.item]
        
        cell.update(mapItemType: mapItem.mapItemType)
        
        return cell
    }
}
