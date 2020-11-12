//
//  ViewWithMapController+.swift
//  Rover
//
//  Created by Anton Borisenko on 10/23/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

extension MapCreationViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        let widthPaddingSpace = sectionInsets.left + sectionInsets.right + minimumItemSpacing * (CGFloat(integerLiteral: itemsPerRow) - 1)
        
        let availableWidth = collectionView.bounds.width - widthPaddingSpace
        
        let widthPerItem = availableWidth / CGFloat(integerLiteral: itemsPerRow)
     
        let heightPaddingSpace = sectionInsets.top + sectionInsets.bottom + minimumItemSpacing * (CGFloat(integerLiteral: rowsCount) - 1)
        
        let availableHeight = collectionView.bounds.height - heightPaddingSpace
        
        let heightPerItem = availableHeight / CGFloat(integerLiteral: rowsCount)
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
     
        return minimumItemSpacing
    }
}
