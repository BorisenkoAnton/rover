//
//  SceneFactory.swift
//  Rover
//
//  Created by Anton Borisenko on 10/23/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

class SceneFactory {
    
    static func mapCreationScene() -> UINavigationController {
        
        let mapCreationViewController = MapCreationViewController()
        
        let mapCreationNavigationController = UINavigationController.init(rootViewController: mapCreationViewController)
        
        let mapPresenter = MapPresenter()
        
        mapPresenter.setViewDelegate(viewWithMapControllerDelegate: mapCreationViewController)
        
        mapCreationViewController.setMapPresenterDelegate(delegate: mapPresenter)
        
        return mapCreationNavigationController
    }
    
    
    static func storageScene() -> UINavigationController {
        
        let storageViewController = StorageViewController()
        
        let storageNavigationController = UINavigationController.init(rootViewController: storageViewController)
        
        let storagePresenter = StoragePresenter()
        
        storagePresenter.setViewDelegate(storageViewControllerDelegate: storageViewController)
        
        storageViewController.setStoragePresenterDelegate(delegate: storagePresenter)
        
        return storageNavigationController
    }
}
